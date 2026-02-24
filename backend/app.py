import time
import random
import pandas as pd
from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# --- 1. CHARGEMENT DU DATASET ECOLE  ---
try:
    df_archive = pd.read_csv('AI4BMI_predictive_maintenance_dataset.csv')
    print("Dataset CSV chargé avec succès pour les archives." )
except Exception as e:
    print(f"Erreur lors du chargement du CSV : {e}")
    df_archive = None

# --- 2. CONFIGURATION DU PARC (TEMPS RÉEL) ---
machines_list = []
configs = [
    {"prefix": "KUKA", "count": 5, "brand": "KUKA", "type": "Robot"},
    {"prefix": "FANUC", "count": 12, "brand": "FANUC", "type": "CNC"},
    {"prefix": "SCHULER", "count": 8, "brand": "SCHULER", "type": "Presse"},
    {"prefix": "SIEMENS", "count": 3, "brand": "SIEMENS", "type": "Moteur"},
]

for config in configs:
    for i in range(1, config["count"] + 1):
        machines_list.append({
            "machine_id": f"{config['prefix']}_{i:02d}",
            "name": f"{config['type']} {config['brand']} n°{i}",
            "brand": config["brand"],
            "machine_type": config["type"]
        })

machine_profiles = {
    "Robot": {"thermal": 1.2, "vib": 1.4, "curr": 0.9},
    "CNC": {"thermal": 1.3, "vib": 1.0, "curr": 1.2},
    "Presse": {"thermal": 0.9, "vib": 1.6, "curr": 1.0},
    "Moteur": {"thermal": 1.5, "vib": 0.8, "curr": 1.4}
}

history_db = {m['machine_id']: [] for m in machines_list}

# --- 3. MOTEUR DE SIMULATION HARMONISÉ ---
def generate_sensor_data(m_id):
    m_type = next(m['machine_type'] for m in machines_list if m['machine_id'] == m_id)
    profile = machine_profiles[m_type]

    last_data = history_db[m_id][-1] if history_db[m_id] else None
    last_temp = last_data['temp_mean'] if last_data else 55.0
    last_status = last_data['status'] if last_data else "active"

    # Calcul Température (Cohérence physique)
    base_var = random.uniform(-2.5, 3.5)
    if last_status == "warning": base_var += 1.0
    if last_status == "en panne": base_var += 2.0
    
    cooling = (last_temp - 55) * 0.04
    new_temp = max(40, min(last_temp + base_var - cooling, 105))

    # Calcul Vibrations et Courant
    vib_mean = round(max(2, (45 + (new_temp - 50) * 1.2) * profile["vib"] / 10 + random.uniform(-1, 1)), 2)
    current_mean = round(max(10, (18 + (new_temp - 50) * 0.08) * profile["curr"] + random.uniform(-1, 1)), 1)

    # Nouveaux capteurs du Dataset
    acoustic = round(random.uniform(80, 115), 2)
    rpm = round(random.uniform(1200, 1600), 1)
    oil = round(random.uniform(40, 75), 2)
    age = 120 # Fixe pour la démo

    # Logique de Statut et Prédiction
    is_failure = new_temp > 95 or vib_mean > 15 or current_mean > 35
    is_warning = new_temp > 85 or vib_mean > 10 or current_mean > 25
    
    failure_next_24h = 1 if is_warning or is_failure else 0

    if is_failure:
        status = "en panne"
        current_mean, rpm, acoustic = 0.0, 0.0, 20.0 # Machine à l'arrêt
    elif is_warning:
        status = "warning"
    else:
        status = "active"

    data = {
        "machine_id": m_id,
        "timestamp": time.strftime("%d/%m/%Y %H:%M"),
        "temp_mean": round(new_temp, 2),
        "temp_max": round(new_temp + random.uniform(1, 3), 2),
        "vib_mean": vib_mean,
        "current_mean": current_mean,
        "acoustic_energy": acoustic,
        "rpm_mean": rpm,
        "oil_particle_count": oil,
        "maintenance_age_days": age,
        "failure_next_24h": failure_next_24h,
        "status": status
    }

    history_db[m_id].append(data)
    if len(history_db[m_id]) > 20: history_db[m_id].pop(0)
    return data

# --- 4. ROUTES API ---

@app.route('/api/machines', methods=['GET'])
def get_all_machines():
    """Temps réel pour le Dashboard"""
    results = []
    for m in machines_list:
        dynamic = generate_sensor_data(m['machine_id'])
        results.append({**m, **dynamic})
    return jsonify(results)

from urllib.parse import unquote

@app.route('/api/archive', methods=['GET'])
def get_archives():
    if df_archive is None:
        return jsonify({"error": "Fichier CSV non trouvé"}), 500
    
    # Récupérer et décoder la date (transforme %2F en /)
    raw_date = request.args.get('date')
    target_date = unquote(raw_date) if raw_date else None
    
    if not target_date:
        return jsonify({"error": "Veuillez préciser une date (JJ/MM/AAAA)"}), 400

    mask = df_archive['timestamp'].str.contains(target_date, na=False)
    filtered_df = df_archive[mask]
    data = filtered_df.replace({np.nan: None}).to_dict(orient='records')
    print(f"DEBUG: Date reçue: {raw_date} | Date décodée: {target_date} | Lignes: {len(filtered_df)}")
    
    return jsonify(data)

@app.route('/api/machines/<m_id>', methods=['GET'])
def get_one_machine(m_id):
    """Détails et Historique court pour le graphique"""
    static_info = next((m for m in machines_list if m['machine_id'] == m_id), None)
    if not static_info:
        return jsonify({"error": "ID inconnu"}), 404
    
    current = generate_sensor_data(m_id)
    return jsonify({
        "info": static_info,
        "current": current,
        "history": history_db[m_id]
    })

@app.route('/api/test/force-failure/<m_id>', methods=['POST'])
def force_failure(m_id):
    if m_id in history_db:
        # Injection d'une donnée critique
        fail_data = generate_sensor_data(m_id)
        fail_data.update({"temp_mean": 99.0, "vib_mean": 25.0, "status": "en panne", "failure_next_24h": 1})
        history_db[m_id].append(fail_data)
        return jsonify({"message": f"Alerte envoyée pour {m_id}"})
    return jsonify({"error": "ID inconnu"}), 404

if __name__ == '__main__':
    app.run(debug=True, port=5000, host='0.0.0.0')