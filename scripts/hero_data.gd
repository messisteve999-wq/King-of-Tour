extends RefCounted

static func get_heroes() -> Array[Dictionary]:
    var names := [
        ["Aro", "Guerrier", "Frappe puissante"], ["Bakar", "Guerrier", "Cri de guerre"],
        ["Dagan", "Guerrier", "Charge brutale"], ["Koro", "Guerrier", "Garde de fer"],
        ["Tarek", "Guerrier", "Lame tournoyante"], ["Luma", "Archer", "Flèche triple"],
        ["Sira", "Archer", "Tir précis"], ["Naya", "Archer", "Pluie de flèches"],
        ["Zuri", "Archer", "Tir perforant"], ["Kena", "Archer", "Œil du faucon"],
        ["Azura", "Mage", "Orbe arcanique"], ["Mirem", "Mage", "Vague de feu"],
        ["Solan", "Mage", "Éclair solaire"], ["Veyra", "Mage", "Rafale magique"],
        ["Orun", "Mage", "Tempête mystique"], ["Barok", "Gardien", "Bouclier total"],
        ["Duma", "Gardien", "Provocation"], ["Kemba", "Gardien", "Mur vivant"],
        ["Rokan", "Gardien", "Contre-attaque"], ["Tuma", "Gardien", "Protection"],
        ["Nyx", "Assassin", "Frappe furtive"], ["Zarek", "Assassin", "Double lame"],
        ["Vasha", "Assassin", "Poison rapide"], ["Kiro", "Assassin", "Ombre vive"],
        ["Selen", "Assassin", "Exécution"], ["Eloa", "Druide", "Soin naturel"],
        ["Mako", "Druide", "Racines entravantes"], ["Talia", "Druide", "Floraison"],
        ["Osei", "Druide", "Esprit protecteur"], ["Nuru", "Druide", "Lumière verte"],
        ["Boro", "Ingénieur", "Tourelle rapide"], ["Kazi", "Ingénieur", "Mine explosive"],
        ["Fero", "Ingénieur", "Canon renforcé"], ["Jengo", "Ingénieur", "Réparation"],
        ["Meka", "Ingénieur", "Drone mécanique"], ["Imani", "Invocateur", "Loup spectral"],
        ["Zeph", "Invocateur", "Esprits du vent"], ["Aruna", "Invocateur", "Phénix mineur"],
        ["Khemu", "Invocateur", "Golem de sable"], ["Sefu", "Invocateur", "Corbeaux mystiques"],
        ["Malik", "Champion", "Coup royal"], ["Amara", "Champion", "Danse des lames"],
        ["Jabari", "Champion", "Rugissement"], ["Asha", "Champion", "Élan héroïque"],
        ["Kofi", "Champion", "Poing de pierre"], ["Raim", "Légendaire", "Foudre royale"],
        ["Thalos", "Légendaire", "Faille terrestre"], ["Elyra", "Légendaire", "Étoiles jumelles"],
        ["Obasi", "Légendaire", "Gardien ancestral"], ["Kairo", "Légendaire", "Temps suspendu"]
    ]
    var result: Array[Dictionary] = []
    for i in range(names.size()):
        result.append({
            "id": i + 1,
            "name": names[i][0],
            "role": names[i][1],
            "power": names[i][2],
            "level": 1,
            "unlocked": true
        })
    return result
