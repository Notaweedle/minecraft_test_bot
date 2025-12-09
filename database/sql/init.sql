CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";


-- USERS
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username TEXT UNIQUE,
	password TEXT,
	minecraft_username text
);

-- COMMANDS
CREATE TABLE commands (
    command_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    raw_command TEXT NOT NULL,
    parsed_action TEXT,
    parsed_item TEXT,
    submitted_by UUID REFERENCES users(user_id),
    submitted_at TIMESTAMP DEFAULT NOW()
);

-- LOGS
CREATE TABLE command_logs (
    log_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    command_id UUID REFERENCES commands(command_id),
    log_message TEXT,
    minecraft_output TEXT,
    status TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- QUEUE
CREATE TABLE minecraft_queue (
    queue_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    command_id UUID REFERENCES commands(command_id),
    is_sent BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP
);

CREATE TABLE available_commands (
    command_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
	name TEXT NOT NULL UNIQUE,
    aliases TEXT[],
    
	description TEXT,
    syntax TEXT NOT NULL,
    pattern_regex TEXT,
    
	enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO available_commands (name, syntax, pattern_regex, description, aliases, enabled) VALUES
('advancement', '/advancement <action> <criteria>', '/advancement .*', 'Gives, removes, or checks player advancements.', NULL, TRUE),
('attribute', '/attribute <target> <attribute> <action>', '/attribute .*', 'Queries, adds, removes or sets an entity attribute.', NULL, TRUE),
('ban', '/ban <player>', '/ban .*', 'Adds player to banlist.', NULL, TRUE),
('ban-ip', '/ban-ip <address>', '/ban-ip .*', 'Adds IP address to banlist.', NULL, TRUE),
('banlist', '/banlist', '/banlist', 'Displays banlist.', NULL, TRUE),
('bossbar', '/bossbar <args>', '/bossbar .*', 'Creates and modifies bossbars.', NULL, TRUE),
('clear', '/clear <target> [item]', '/clear .*', 'Clears items from player inventory.', NULL, TRUE),
('clone', '/clone <begin> <end> <destination>', '/clone .*', 'Copies blocks from one place to another.', NULL, TRUE),
('damage', '/damage <target> <amount>', '/damage .*', 'Applies damage to the specified entities.', NULL, TRUE),
('data', '/data <args>', '/data .*', 'Modifies or queries block/entity/command storage NBT data.', NULL, TRUE),
('datapack', '/datapack <enable|disable|list>', '/datapack .*', 'Controls loaded data packs.', NULL, TRUE),
('debug', '/debug <start|stop>', '/debug .*', 'Starts or stops a debugging session.', NULL, TRUE),
('defaultgamemode', '/defaultgamemode <mode>', '/defaultgamemode .*', 'Sets the default game mode.', NULL, TRUE),
('deop', '/deop <player>', '/deop .*', 'Revokes operator status from a player.', NULL, TRUE),
('dialog', '/dialog <args>', '/dialog .*', 'Shows dialog to clients.', NULL, TRUE),
('difficulty', '/difficulty <mode>', '/difficulty .*', 'Sets the difficulty level.', NULL, TRUE),
('effect', '/effect <args>', '/effect .*', 'Adds or removes status effects.', NULL, TRUE),
('enchant', '/enchant <player> <enchantment> <level>', '/enchant .*', 'Adds an enchantment to a player’s selected item.', NULL, TRUE),
('execute', '/execute <args>', '/execute .*', 'Executes another command.', NULL, TRUE),
('experience', '/experience <args>', '/experience .*', 'Adds or removes player experience.', ARRAY['xp'], TRUE),
('xp', '/xp <args>', '/xp .*', 'Adds or removes player experience.', ARRAY['experience'], TRUE),
('fetchprofile', '/fetchprofile <player>', '/fetchprofile .*', 'Fetches a player profile.', NULL, TRUE),
('fill', '/fill <begin> <end> <block>', '/fill .*', 'Fills a region with a block.', NULL, TRUE),
('fillbiome', '/fillbiome <begin> <end> <biome>', '/fillbiome .*', 'Fills a region with a biome.', NULL, TRUE),
('forceload', '/forceload <add|remove|query>', '/forceload .*', 'Forces chunks to remain loaded.', NULL, TRUE),
('function', '/function <name>', '/function .*', 'Runs a function.', NULL, TRUE),
('gamemode', '/gamemode <mode> [player]', '/gamemode .*', 'Sets a player’s game mode.', NULL, TRUE),
('gamerule', '/gamerule <rule> <value>', '/gamerule .*', 'Sets or queries a game rule.', NULL, TRUE),
('give', '/give <target> <item> <count>', '/give .*', 'Gives an item to a player.', NULL, TRUE),
('help', '/help [command]', '/help .*', 'Provides help for commands.', NULL, TRUE),
('item', '/item <args>', '/item .*', 'Manipulates items in inventories.', NULL, TRUE),
('jfr', '/jfr <start|stop>', '/jfr .*', 'Starts or stops JFR profiling.', NULL, TRUE),
('kick', '/kick <player> [reason]', '/kick .*', 'Kicks a player.', NULL, TRUE),
('kill', '/kill <target>', '/kill .*', 'Kills entities.', NULL, TRUE),
('list', '/list', '/list', 'Lists players on the server.', NULL, TRUE),
('locate', '/locate <structure|biome|poi>', '/locate .*', 'Locates nearest structure, biome, or POI.', NULL, TRUE),
('loot', '/loot <args>', '/loot .*', 'Drops or gives items from loot tables.', NULL, TRUE),
('me', '/me <message>', '/me .*', 'Displays a message about the sender.', NULL, TRUE),
('msg', '/msg <player> <message>', '/msg .*', 'Private message to a player.', ARRAY['tell','w'], TRUE),
('tell', '/tell <player> <message>', '/tell .*', 'Private message to a player.', ARRAY['msg','w'], TRUE),
('tellraw', '/tellraw <player> <message>', '/tellraw .*', 'Sends a Json message to a player.', ARRAY['msg','w'], TRUE),
('w', '/w <player> <message>', '/w .*', 'Private message to a player.', ARRAY['msg','tell'], TRUE),
('op', '/op <player>', '/op .*', 'Grants operator status.', NULL, TRUE),
('pardon', '/pardon <player>', '/pardon .*', 'Removes player from banlist.', NULL, TRUE),
('pardon-ip', '/pardon-ip <address>', '/pardon-ip .*', 'Removes IP from banlist.', NULL, TRUE),
('particle', '/particle <args>', '/particle .*', 'Creates particles.', NULL, TRUE),
('perf', '/perf', '/perf', 'Captures game metrics.', NULL, TRUE),
('place', '/place <feature>', '/place .*', 'Places configured features/structures.', NULL, TRUE),
('playsound', '/playsound <sound> <target> <pos> [volume]', '/playsound .*', 'Plays a sound.', NULL, TRUE),
('publish', '/publish', '/publish', 'Opens single-player world to LAN.', NULL, TRUE),
('random', '/random <value|sequence>', '/random .*', 'Draws a random value or controls RNG.', NULL, TRUE),
('recipe', '/recipe <give|take> <player> <recipe>', '/recipe .*', 'Gives or takes player recipes.', NULL, TRUE),
('reload', '/reload', '/reload', 'Reloads data from disk.', NULL, TRUE),
('return', '/return <value>', '/return .*', 'Controls function return values.', NULL, TRUE),
('ride', '/ride <args>', '/ride .*', 'Make entities ride or dismount.', NULL, TRUE),
('rotate', '/rotate <entity> <rotation>', '/rotate .*', 'Changes entity rotation.', NULL, TRUE),
('save-all', '/save-all', '/save-all', 'Saves world to disk.', NULL, TRUE),
('save-off', '/save-off', '/save-off', 'Disables auto save.', NULL, TRUE),
('save-on', '/save-on', '/save-on', 'Enables auto save.', NULL, TRUE),
('say', '/say <message>', '/say .*', 'Broadcasts a message.', NULL, TRUE),
('schedule', '/schedule <function> <delay>', '/schedule .*', 'Delays function execution.', NULL, TRUE),
('scoreboard', '/scoreboard <args>', '/scoreboard .*', 'Manages scoreboard.', NULL, TRUE),
('seed', '/seed', '/seed', 'Displays world seed.', NULL, TRUE),
('setblock', '/setblock <pos> <block>', '/setblock .*', 'Changes a block.', NULL, TRUE),
('setidletimeout', '/setidletimeout <minutes>', '/setidletimeout .*', 'Sets idle kick timer.', NULL, TRUE),
('setworldspawn', '/setworldspawn [pos]', '/setworldspawn .*', 'Sets world spawn.', NULL, TRUE),
('spawnpoint', '/spawnpoint <player> [pos]', '/spawnpoint .*', 'Sets player spawn point.', NULL, TRUE),
('spectate', '/spectate <target> [player]', '/spectate .*', 'Makes a player spectate an entity.', NULL, TRUE),
('spreadplayers', '/spreadplayers <args>', '/spreadplayers .*', 'Teleports entities to random places.', NULL, TRUE),
('stop', '/stop', '/stop', 'Stops the server.', NULL, TRUE),
('stopsound', '/stopsound <targets> [sound]', '/stopsound .*', 'Stops a sound.', NULL, TRUE),
('summon', '/summon <entity> [pos]', '/summon .*', 'Summons an entity.', NULL, TRUE),
('tag', '/tag <entity> <add|remove|list>', '/tag .*', 'Controls entity tags.', NULL, TRUE),
('team', '/team <args>', '/team .*', 'Controls teams.', NULL, TRUE),
('teammsg', '/teammsg <message>', '/teammsg .*', 'Sends a message to team.', ARRAY['tm'], TRUE),
('tm', '/tm <message>', '/tm .*', 'Sends a message to team.', ARRAY['teammsg'], TRUE),
('teleport', '/teleport <args>', '/teleport .*', 'Teleports entities.', ARRAY['tp'], TRUE),
('tp', '/tp <args>', '/tp .*', 'Teleports entities.', ARRAY['teleport'], TRUE),
('test', '/test <args>', '/test .*', 'Manage and execute GameTests.', NULL, TRUE),
('tick', '/tick <args>', '/tick .*', 'Controls the tick rate of the game.', NULL, TRUE),
('time', '/time <args>', '/time .*', 'Changes or queries the world\s game time.', NULL, TRUE),
('title', '/title <args>', '/title .*', 'Manages screen titles.', NULL, TRUE),
('transfer', '/transfer <player> <server>', '/transfer .*', 'Transfers a player to another server.', NULL, TRUE),
('trigger', '/trigger <objective> <set|add> <value>', '/trigger .*', 'Sets a trigger objective.', NULL, TRUE),
('version', '/version', '/version', 'Shows server version.', NULL, TRUE),
('waypoint', '/waypoint <args>', '/waypoint .*', 'Manages locator bar waypoints.', NULL, TRUE),
('weather', '/weather <clear|rain|thunder>', '/weather .*', 'Sets the weather.', NULL, TRUE),
('whitelist', '/whitelist <args>', '/whitelist .*', 'Manages server whitelist.', NULL, TRUE),
('worldborder', '/worldborder <args>', '/worldborder .*', 'Manages the world border.', NULL, TRUE);

