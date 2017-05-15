
//shpis types
var ShipType = {
    JetFighter: 0,
    HeavyFighter: 1,
    Cruiser: 2,
    Drednot: 3,
    Destroyer: 4,
    Superdestroyer: 5
}

// two possible players
var Owner = {
    PlayerA: "PlayerA",
    PlayerB: "PlayerB"
}

function Ship(type, owner, attack, defense, fireRate, range, durability, imgSrc) {
    this.type = type
    this.attack = attack
    this.defense = defense
    this.durability = durability
    this.fireRate = fireRate
    this.range = range
    this.points = durability
    this.owner = owner
    this.imgSrc = imgSrc

    // hit ship
    // if returned false, ship is not destroyed
    // if returned true, ship is destroyed
    this.hit = function(attack) {
        if(attack > this.defense) {
            this.points = this.points - attack + defense;

            if(this.points <= 0) {
                if(owner === "PlayerA") {
                    playerBScore += this.durability / 100;
                }
                if(owner === "PlayerB") {
                    playerAScore += this.durability / 100;
                }
                return true;
            }
            else if(Math.random() * this.durability * this.durability < this.points * this.points) {
                return false;
            }
            else {
                if(owner === "PlayerA") {
                    playerBScore += this.durability / 100;
                }
                if(owner === "PlayerB") {
                    playerAScore += this.durability / 100;
                }
                return true;
            }
        }
    } // hit method
} // ship object

//conctruct initial ship with all params by type
function shipByType(shipType, owner) {
    switch(shipType) {

    case ShipType.JetFighter:
        return new Ship(shipType, owner, 10, 4, 300, 100, 200, "jetfighter.jpg");

    case ShipType.HeavyFighter:
        return new Ship(shipType, owner, 20, 8, 350, 120, 350, "heavyfighter-1.jpg");

    case ShipType.Cruiser:
        return new Ship(shipType, owner, 50, 15, 600, 140, 600, "cruiser.jpg");

    case ShipType.Drednot:
        return new Ship(shipType, owner, 100, 25, 1000, 160, 1150, "drednot.jpg");

    case ShipType.Destroyer:
        return new Ship(shipType, owner, 250, 40, 1000, 180, 2670, "destroyer.jpg");

    case ShipType.Superdestroyer:
        return new Ship(shipType, owner, 4000, 100, 2000, 200, 65000, "superdestroyer.jpg");
    }
} // shipByType



