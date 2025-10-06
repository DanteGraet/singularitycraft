return {
    gamemode = "classic",
    playerGun = "classic/classicPistol",
    enemyGun = "*pickedRandomly, no default",
    save = dante.load("save/classic.lua") or {kills = 0, deaths = 0},

    fade = -1,

    onGameOver = function(winner, loser)
        if loser.team == "enemy" then
            gameSettings.save.kills = gameSettings.save.kills + 1
        else
            gameSettings.save.deaths = gameSettings.save.deaths + 1
        end

        gameSettings.fade = 0
        winner.health.isInvincible = true
    end
}