

function Get-WorldFiles {
    $files = @(
        "biome.db",
        "biomeRandSeed.txt",
        "clientTagLog.txt",
        "curseCount.db",
        "curseLog", # FOLDER
        "curses.db",
        "curseSave.txt",
        "eve.db",
        "evePlacementHomelandLog.txt",
        "eveRadius.txt",
        "failureLog", # FOLDER
        "familyDataLog.txt",
        "floor.db",
        "floorTime.db",
        "foodLog", # FOLDER
        "grave.db",
        "grave.db.trunc",
        "killHitLog", # FOLDER
        "lastEveLocation.txt",
        "lifeLog" # FOLDER
        "log.txt",
        "lookTime.db",
        "map.db",
        "mapChangeLogs", # FOLDER
        "mapDummyRecall.txt",
        "mapTime.db",
        "meta.db"
        "monumentLogs", # FOLDER
        "playerStats.db",
        "recentPlacements.txt",
        "shutdownLongLineagePos.txt"
    )
    return $files
}