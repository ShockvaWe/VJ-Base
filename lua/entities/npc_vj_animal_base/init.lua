if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
include('schedules.lua')
/*--------------------------------------------------
	=============== Animal SNPC Base ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used as a base for animal SNPCs.
--------------------------------------------------*/
AccessorFunc(ENT,"m_iClass","NPCClass",FORCE_NUMBER)
AccessorFunc(ENT,"m_fMaxYawSpeed","MaxYawSpeed",FORCE_NUMBER)
ENT.IsVJBaseSNPC = true -- Is it a VJ Base SNPC?
ENT.IsVJBaseSNPC_Animal = true -- Is it a VJ Base animal?

	-- General ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = GetConVarNumber("vj_snpchealth")
ENT.HullType = HULL_TINY
ENT.HasHull = true -- Set to false to disable HULL
ENT.HullSizeNormal = true -- set to false to cancel out the self:SetHullSizeNormal()
ENT.HasSetSolid = true -- set to false to disable SetSolid
ENT.SightAngle = 80 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.TurningSpeed = 20 -- How fast it can turn
ENT.VJ_IsHugeMonster = false -- Is this a huge monster?
	-- ====== Movement Code ====== --
	-- Types: VJ_MOVETYPE_GROUND | VJ_MOVETYPE_AERIAL | VJ_MOVETYPE_AQUATIC | VJ_MOVETYPE_STATIONARY | VJ_MOVETYPE_PHYSICS
ENT.MovementType = VJ_MOVETYPE_GROUND -- How does the SNPC move?
ENT.CanTurnWhileStationary = true -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
	-- Blood & Damages ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.GodMode = false -- Immune to everything
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle and etc.)
ENT.HasBloodParticle = true -- Does it spawn a particle when damaged?
ENT.HasBloodPool = true -- Does it have a blood pool?
ENT.HasBloodDecal = true -- Does it spawn a decal when damaged?
ENT.BloodParticle = {"blood_impact_red_01"} -- Particle that the SNPC spawns when it's damaged
ENT.BloodPoolParticle = {} -- Leave empty for the base to decide which pool blood it should use
ENT.BloodDecal = {"Blood"} -- Leave blank for none | Commonly used: Red = Blood, Yellow Blood = YellowBlood
ENT.BloodDecalRate = 1000 -- The bigger the number, the more chance it has of spawning the decal | Remember to use 5 or 10 when using big decals (Ex: Antlion Splat)
ENT.BloodDecalDistance = 300 -- How far the decal can spawn
ENT.GetDamageFromIsHugeMonster = false -- Should it get damaged no matter what by SNPCs that are tagged as VJ_IsHugeMonster?
ENT.AllowIgnition = true -- Can this SNPC be set on fire?
ENT.Immune_Dissolve = false -- Immune to Dissolving | Example: Combine Ball
ENT.Immune_AcidPoisonRadiation = false -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = false -- Immune to Bullets
ENT.Immune_Blast = false -- Immune to Explosives
ENT.Immune_Electricity = false -- Immune to Electrical
ENT.Immune_Freeze = false -- Immune to Freezing
ENT.Immune_Physics = false -- Immune to Physics
ENT.ImmuneDamagesTable = {} -- You can set Specific types of damages for the SNPC to be immune to
ENT.RunAwayOnUnknownDamage = true -- Should run away on damage
ENT.CallForBackUpOnDamage = true -- Should the SNPC call for help when damaged? (Only happens if the SNPC hasn't seen a enemy)
ENT.CallForBackUpOnDamageDistance = 800 -- How far away the SNPC's call for help goes | Counted in World Units
ENT.CallForBackUpOnDamageUseCertainAmount = false -- Should the SNPC only call certain amount of people?
ENT.CallForBackUpOnDamageUseCertainAmountNumber = 3 -- How many people should it call if certain amount is enabled?
ENT.DisableCallForBackUpOnDamageAnimation = true -- Disables the animation when the CallForBackUpOnDamage function is called
ENT.CallForBackUpOnDamageAnimation = {ACT_SIGNAL_HALT} -- Animation used if the SNPC does the CallForBackUpOnDamage function
ENT.CallForBackUpOnDamageAnimationTime = 2 -- How much time until it can use activities
ENT.NextCallForBackUpOnDamageTime1 = 9 -- Next time it use the CallForBackUpOnDamage function | The first # in math.random
ENT.NextCallForBackUpOnDamageTime2 = 11 -- Next time it use the CallForBackUpOnDamage function | The second # in math.random
ENT.HasDamageByPlayer = true -- Should the SNPC do something when it's hit by a player? Example: Play a sound or animation
ENT.DamageByPlayerDispositionLevel = 0 -- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
ENT.DamageByPlayerNextTime1 = 2 -- How much time should it pass until it runs the code again? | First number in math.random
ENT.DamageByPlayerNextTime2 = 2 -- How much time should it pass until it runs the code again? | Second number in math.random
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 0 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchDamageTypes = {DMG_BLAST} -- If it uses damage-based flinching, which types of damages should it flinch from?
ENT.FlinchChance = 16 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.NextMoveAfterFlinchTime = "LetBaseDecide" -- How much time until it can move, attack, etc. | Use this for schedules or else the base will set the time 0.6 if it sees it's a schedule!
ENT.NextFlinchTime = 5 -- How much time until it can flinch again?
ENT.FlinchAnimation_UseSchedule = false -- false = SCHED_ | true = ACT_
ENT.ScheduleTbl_Flinch = {SCHED_FLINCH_PHYSICS} -- If it uses schedule-based animation, implement the schedule types here | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this
ENT.FlinchAnimationDecreaseLengthAmount = 0 -- This will decrease the time it can move, attack, etc. | Use it to fix animation pauses after it finished the flinch animation
ENT.HasHitGroupFlinching = false -- It will flinch when hit in certain hitgroups | It can also have certain animations to play in certain hitgroups
ENT.HitGroupFlinching_DefaultWhenNotHit = true -- If it uses hitgroup flinching, should it do the regular flinch if it doesn't hit any of the specified hitgroups?
ENT.HitGroupFlinching_Values = {/* EXAMPLES: {HitGroup = {1}, IsSchedule = true, Animation = {SCHED_BIG_FLINCH}},{HitGroup = {4}, IsSchedule = false, Animation = {ACT_FLINCH_STOMACH}} */} -- if "IsSchedule" is set to true, "Animation" needs to be a schedule
	-- Relationships ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasAllies = true -- Put to false if you want it not to have any allies
ENT.VJ_NPC_Class = {} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.PlayerFriendly = false -- Makes the SNPC friendly to the player and HL2 Resistance
ENT.FriendlyToVJSNPCs = true -- Set to true if you want it to be friendly to all of VJ SNPCs
ENT.BecomeEnemyToPlayer = false -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
ENT.BecomeEnemyToPlayerLevel = 2 -- How many times does the player have to hit the SNPC for it to become enemy?
ENT.BecomeEnemyToPlayerSetPlayerFriendlyFalse = true -- Should it set PlayerFriendly to false?
ENT.HasOnPlayerSight = false -- Should do something when it sees the enemy? Example: Play a sound
ENT.OnPlayerSightDistance = 200 -- How close should the player be until it runs the code?
ENT.OnPlayerSightDispositionLevel = 0 -- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
ENT.OnPlayerSightOnlyOnce = true -- Should it only run the code once?
ENT.OnPlayerSightNextTime1 = 15 -- How much time should it pass until it runs the code again? | First number in math.random
ENT.OnPlayerSightNextTime2 = 20 -- How much time should it pass until it runs the code again? | Second number in math.random
	-- Death ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasDeathRagdoll = true -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.DeathCorpseEntityClass = "UseDefaultBehavior" -- The entity class it creates | "UseDefaultBehavior" = Let the base automatically detect the type
ENT.CorpseAlwaysCollide = false -- Should the corpse always collide?
ENT.HasDeathBodyGroup = true -- Set to true if you want to put a bodygroup when it dies
ENT.CustomBodyGroup = false -- Set true if you want to set custom bodygroup
ENT.DeathBodyGroupA = 0 -- Used for Custom Bodygroup | Group = A
ENT.DeathBodyGroupB = 0 -- Used for Custom Bodygroup | Group = B
ENT.DeathSkin = 0 -- Used to override the death skin | 0 = Use the skin that the SNPC had before it died
ENT.FadeCorpse = false -- Fades the ragdoll on death
ENT.FadeCorpseTime = 10 -- How much time until the ragdoll fades | Unit = Seconds
ENT.HasDeathAnimation = false -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIESIMPLE} -- Death Animations
ENT.DeathAnimationTime = 1 -- Time until the SNPC spawns its corpse and gets removed
ENT.DeathAnimationChance = 1 -- Put 1 if you want it to play the animation all the time
ENT.DisableDeathAnimationSCHED = false -- If set to true, it will disable the setschedule code
ENT.WaitBeforeDeathTime = 0 -- Time until the SNPC spawns its corpse and gets removed
ENT.SetCorpseOnFire = false -- Sets the corpse on fire when the SNPC dies
ENT.HasDeathNotice = false -- Set to true if you want it show a message after it dies
ENT.DeathNoticePosition = HUD_PRINTCENTER -- Were you want the message to show. Examples: HUD_PRINTCENTER, HUD_PRINTCONSOLE, HUD_PRINTTALK
ENT.DeathNoticeWriting = "Example: Spider Queen Has Been Defeated!" -- Message that will appear
ENT.UsesBoneAngle = true -- This can be used to stop the corpse glitching or flying on death
ENT.UsesDamageForceOnDeath = true -- Disables the damage force on death | Useful for SNPCs with Death Animations
ENT.HasItemDropsOnDeath = true -- Should it drop items on death?
ENT.ItemDropsOnDeathChance = 14 -- If set to 1, it will always drop it
ENT.ItemDropsOnDeath_EntityList = {} -- List of items it will randomly pick from | Leave it empty to drop nothing or to make your own dropping code (Using CustomOn...)
ENT.BringFriendsOnDeath = true -- Should the SNPC's friends come to its position before it dies?
ENT.BringFriendsOnDeathDistance = 800 -- How far away does the signal go? | Counted in World Units
ENT.BringFriendsOnDeathUseCertainAmount = false -- Should the SNPC only call certain amount of people?
ENT.BringFriendsOnDeathUseCertainAmountNumber = 3 -- How many people should it call if certain amount is enabled?
ENT.AllowedToGib = true -- Is it allowed to gib in general? This can be on death or when shot in a certain place
ENT.HasGibOnDeath = true -- Is it allowed to gib on death?
ENT.GibOnDeathDamagesTable = {} -- Damages that it gibs from | "UseDefault" = Uses default damage types | "All" = Gib from any damage
ENT.HasGibOnDeathSounds = true -- Does it have gib sounds? | Mostly used for the settings menu
ENT.HasGibDeathParticles = true -- Does it spawn particles on death or when it gibs? | Mostly used for the settings menu
	-- Miscellaneous ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.RunOnTouch = true -- Runs away when something touches it
ENT.NextRunOnTouchTime = 3 -- Next time it runs away when something touches it
ENT.IdleSchedule_Wander = {SCHED_IDLE_WANDER} -- Animation played when the SNPC is idle, when called to wander
ENT.AnimTbl_IdleStand = {} -- Leave empty to use schedule | Only works when AI is enabled
ENT.HasEntitiesToNoCollide = true -- If set to false, it won't run the EntitiesToNoCollide code
ENT.EntitiesToNoCollide = {} -- Entities to not collide with when HasEntitiesToNoCollide is set to true
ENT.NextRunAwayOnDamageTime = 5 -- Until next run after being shot when not alerted
ENT.DisableWandering = false -- Disables wandering when the SNPC is idle
ENT.DisableSelectSchedule = false -- Disables Schedule code, Custom Schedule can still work
ENT.DisableInitializeCapabilities = false -- If true, it will disable the initialize capabilities, this will allow you to add your own
ENT.CustomWalkActivites = {} -- Custom walk activities
ENT.CustomRunActivites = {} -- Custom run activities
ENT.HasWorldShakeOnMove = false -- Should the world shake when it's moving?
ENT.NextWorldShakeOnRun = 0.5 -- How much time until the world shakes while it's running
ENT.NextWorldShakeOnWalk = 1 -- How much time until the world shakes while it's walking
ENT.WorldShakeOnMoveAmplitude = 10 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.WorldShakeOnMoveRadius = 1000 -- How far the screen shake goes, in world units
ENT.WorldShakeOnMoveDuration = 0.4 -- How long the screen shake will last, in seconds
ENT.WorldShakeOnMoveFrequency = 100 -- Just leave it to 100
ENT.DisableWorldShakeOnMoveWhileRunning = false -- It will not shake the world when it's running
ENT.DisableWorldShakeOnMoveWhileWalking = false -- It will not shake the world when it's walking
ENT.FollowPlayer = false -- Should the SNPC follow the player when the player presses a certain key?
ENT.FollowPlayerChat = true -- Should the SNPCs say things like "They stopped following you"
ENT.FollowPlayerKey = "Use" -- The key that the player presses to make the SNPC follow them
ENT.FollowPlayerCloseDistance = 150 -- If the SNPC is that close to the player then stand still until the player goes farther away
ENT.NextFollowPlayerTime = 1 -- Time until it runs to the player again
ENT.BringFriendsToMeSCHED1 = SCHED_RUN_FROM_ENEMY -- The Schedule that its friends play when BringAlliesToMe code is ran | First in math.random
ENT.BringFriendsToMeSCHED2 = SCHED_RUN_FROM_ENEMY -- The Schedule that its friends play when BringAlliesToMe code is ran | Second in math.random
	-- Sounds ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasSounds = true -- Put to false to disable ALL sounds
ENT.HasImpactSounds = true -- If set to false, it won't play the impact sounds
ENT.HasAlertSounds = true -- If set to false, it won't play the alert sounds
ENT.HasIdleSounds = true -- If set to false, it won't play the idle sounds
ENT.HasPainSounds = true -- If set to false, it won't play the pain sounds
ENT.HasDeathSounds = true -- If set to false, it won't play the death sounds
ENT.NextOnTouchFearSoundTime = 3 -- Next time it makes a fear sound when something touches it
ENT.HasBecomeEnemyToPlayerSounds = true -- If set to false, it won't play the become enemy to player sounds
ENT.HasFollowPlayerSounds_Follow = true -- If set to false, it won't play the follow player sounds
ENT.HasFollowPlayerSounds_UnFollow = true -- If set to false, it won't play the unfollow player sounds
ENT.HasOnPlayerSightSounds = true -- If set to false, it won't play the saw player sounds
ENT.HasDamageByPlayerSounds = true -- If set to false, it won't play the stupid player sounds
ENT.HasFootStepSound = true -- Should the SNPC make a footstep sound when it's moving?
ENT.FootStepTimeRun = 0.5 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 1 -- Next foot step sound when it is walking
ENT.DisableFootStepSoundTimer = false -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.HasBreathSound = true -- Should it make a breathing sound?
ENT.DisableFootStepOnRun = false -- It will not play the footstep sound when running
ENT.DisableFootStepOnWalk = false -- It will not play the footstep sound when walking
ENT.HasSoundTrack = false -- Does the SNPC have a sound track?
ENT.SoundTrackFadeOutTime = 2  -- Put to 0 if you want it to stop instantly
ENT.PlayAlertSoundOnlyOnce = false -- After it plays it once, it will never play it again
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {}
ENT.SoundTbl_Breath = {}
ENT.SoundTbl_Idle = {}
ENT.SoundTbl_FollowPlayer = {}
ENT.SoundTbl_UnFollowPlayer = {}
ENT.SoundTbl_OnPlayerSight = {}
ENT.SoundTbl_Alert = {}
ENT.SoundTbl_BecomeEnemyToPlayer = {}
ENT.SoundTbl_Pain = {}
ENT.SoundTbl_Impact = {}
ENT.SoundTbl_DamageByPlayer = {}
ENT.SoundTbl_Death = {}
ENT.SoundTbl_SoundTrack = {}

ENT.DefaultSoundTbl_Impact = {"vj_flesh/alien_flesh1.wav"}
	-- ====== Sound Chances ====== --
-- Higher number = less chance of playing | 1 = Always play
-- This are all counted in seconds
ENT.IdleSoundChance = 3
ENT.FollowPlayerSoundChance = 1
ENT.UnFollowPlayerSoundChance = 1
ENT.OnPlayerSightSoundChance = 1
ENT.AlertSoundChance = 1
ENT.BecomeEnemyToPlayerChance = 1
ENT.PainSoundChance = 1
ENT.ImpactSoundChance = 1
ENT.DamageByPlayerSoundChance = 1
ENT.DeathSoundChance = 1
ENT.SoundTrackChance = 1
	-- ====== Sound Timer ====== --
-- Randomized time between the two variables, x amount of time has to pass for the sound to play again
-- This are all counted in seconds
ENT.NextSoundTime_Breath1 = 1
ENT.NextSoundTime_Breath2 = 1
ENT.NextSoundTime_Idle1 = 2
ENT.NextSoundTime_Idle2 = 5
ENT.NextSoundTime_Pain1 = 2
ENT.NextSoundTime_Pain2 = 2
ENT.NextSoundTime_DamageByPlayer1 = 2
ENT.NextSoundTime_DamageByPlayer2 = 2.3
	-- ====== Sound Volume ====== --
-- Number between 0 and 1
-- 0 = No sound, 1 = normal/loudest
ENT.SoundTrackVolume = 1
	-- ====== Sound Levels ====== --
-- EmitSound is from 0 to 511 | CreateSound is from 0 to 180
-- More Information: https://developer.valvesoftware.com/wiki/Soundscripts#SoundLevel_Flags
ENT.FootStepSoundLevel = 70
ENT.BreathSoundLevel = 60
ENT.IdleSoundLevel = 75
ENT.FollowPlayerSoundLevel = 75
ENT.UnFollowPlayerSoundLevel = 75
ENT.OnPlayerSightSoundLevel = 75
ENT.AlertSoundLevel = 80
ENT.BecomeEnemyToPlayerSoundLevel = 75
ENT.PainSoundLevel = 75
ENT.ImpactSoundLevel = 60
ENT.DamageByPlayerSoundLevel = 75
ENT.DeathSoundLevel = 75
//ENT.SoundTrackLevel = 0.9
	-- ====== Sound Pitch ====== --
-- Higher number = Higher pitch | Lower number = Lower pitch
-- Highest number is 254
	-- !!! Important variables !!! --
ENT.UseTheSameGeneralSoundPitch = true 
	-- If set to true, it will make the game decide a number when the SNPC is created and use it for all sound pitches set to "UseGeneralPitch"
	-- It picks the number between the two variables below:
ENT.GeneralSoundPitch1 = 80
ENT.GeneralSoundPitch2 = 100
	-- This two variables control any sound pitch variable that is set to "UseGeneralPitch"
	-- To not use these variables for a certain sound pitch, just put the desired number in the specific sound pitch
ENT.FootStepPitch1 = 80
ENT.FootStepPitch2 = 100
ENT.BreathSoundPitch1 = 100
ENT.BreathSoundPitch2 = 100
ENT.IdleSoundPitch1 = "UseGeneralPitch"
ENT.IdleSoundPitch2 = "UseGeneralPitch"
ENT.FollowPlayerPitch1 = "UseGeneralPitch"
ENT.FollowPlayerPitch2 = "UseGeneralPitch"
ENT.UnFollowPlayerPitch1 = "UseGeneralPitch"
ENT.UnFollowPlayerPitch2 = "UseGeneralPitch"
ENT.OnPlayerSightSoundPitch1 = "UseGeneralPitch"
ENT.OnPlayerSightSoundPitch2 = "UseGeneralPitch"
ENT.AlertSoundPitch1 = "UseGeneralPitch"
ENT.AlertSoundPitch2 = "UseGeneralPitch"
ENT.BecomeEnemyToPlayerPitch1 = "UseGeneralPitch"
ENT.BecomeEnemyToPlayerPitch2 = "UseGeneralPitch"
ENT.PainSoundPitch1 = "UseGeneralPitch"
ENT.PainSoundPitch2 = "UseGeneralPitch"
ENT.ImpactSoundPitch1 = 80
ENT.ImpactSoundPitch2 = 100
ENT.DamageByPlayerPitch1 = "UseGeneralPitch"
ENT.DamageByPlayerPitch2 = "UseGeneralPitch"
ENT.DeathSoundPitch1 = "UseGeneralPitch"
ENT.DeathSoundPitch2 = "UseGeneralPitch"
	-- ====== Sound Playback Rate ====== --
-- How fast should a sound play?
-- 1 = normal, 2 = twice the normal speed, 0.5 = half the normal speed
ENT.SoundTrackPlaybackRate = 1
	-- Independent Variables ---------------------------------------------------------------------------------------------------------------------------------------------
-- These should be left as they are
ENT.Dead = false
ENT.Flinching = false
ENT.TakingCover = false
ENT.VJCorpseDeleted = false
ENT.vACT_StopAttacks = false
ENT.NoLongerLikesThePlayer = false
ENT.FollowingPlayer = false
ENT.DontStartShooting_FollowPlayer = false
ENT.FollowingPlayer_WanderValue = false
ENT.FollowingPlayer_ChaseValue = false
ENT.VJ_IsBeingControlled = false
ENT.VJ_PlayingSequence = false
ENT.VJ_IsPlayingSoundTrack = false
ENT.HasDone_PlayAlertSoundOnlyOnce = false
ENT.OnPlayerSight_AlreadySeen = false
ENT.VJDEBUG_SNPC_ENABLED = false
ENT.AlreadyBeingHealedByMedic = false
ENT.ZombieFriendly = false
ENT.AntlionFriendly = false
ENT.CombineFriendly = false
ENT.Aerial_ShouldBeFlying = false
ENT.IsDoingFaceEnemy = false
ENT.VJ_IsPlayingInterruptSequence = false
ENT.CanDoSelectScheduleAgain = true
ENT.DoingVJDeathDissolve = false
ENT.HasBeenGibbedOnDeath = false
ENT.DeathAnimationCodeRan = false
ENT.FollowingPlayerName = NULL
ENT.MyEnemy = NULL
ENT.VJ_TheController = NULL
ENT.VJ_TheControllerEntity = NULL
ENT.LastPlayedVJSound = nil
ENT.LatestTaskName = nil
ENT.TestT = 0
ENT.NextFollowPlayerT = 0
ENT.AngerLevelTowardsPlayer = 0
ENT.NextBreathSoundT = 0
ENT.FootStepT = 0
ENT.PainSoundT = 0
ENT.WorldShakeWalkT = 0
ENT.NextRunAwayOnDamageT = 0
ENT.NextIdleSoundT = 0
ENT.NextCallForBackUpOnDamageT = 0
ENT.NextRunOnTouchT = 0
ENT.NextOnTouchFearSoundT = 0
ENT.NextCallForHelpAnimationT = 0
ENT.NextIdleTime = 0
ENT.OnPlayerSightNextT = 0
ENT.NextDamageByPlayerT = 0
ENT.NextDamageByPlayerSoundT = 0
ENT.CurrentAnim_IdleStand = 0
ENT.CurrentFlinchAnimation = 0
ENT.CurrentFlinchAnimationDuration = 0
ENT.NextFlinchT = 0
ENT.CurrentAnim_CallForBackUpOnDamage = 0
ENT.NextCanGetCombineBallDamageT = 0
ENT.UseTheSameGeneralSoundPitch_PickedNumber = 0
ENT.SelectedDifficulty = 1
	-- Tables ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HL2_Animals = {"npc_barnacle", "npc_crow", "npc_pigeon", "npc_seagull", "monster_cockroach"}
ENT.HL2_Resistance = {"npc_magnusson", "npc_vortigaunt", "npc_mossman", "npc_monk", "npc_kleiner", "npc_fisherman", "npc_eli", "npc_dog", "npc_barney", "npc_alyx", "npc_citizen"}
ENT.HL2_Combine = {"npc_stalker", "npc_rollermine", "npc_turret_ground", "npc_turret_floor", "npc_turret_ceiling", "npc_strider", "npc_sniper", "npc_metropolice", "npc_hunter", "npc_breen", "npc_combine_camera", "npc_combine_s", "npc_combinedropship", "npc_combinegunship", "npc_cscanner", "npc_clawscanner", "npc_helicopter", "npc_manhack"}
ENT.HL2_Zombies = {"npc_fastzombie_torso", "npc_zombine", "npc_zombie_torso", "npc_zombie", "npc_poisonzombie", "npc_headcrab_fast", "npc_headcrab_black", "npc_headcrab", "npc_fastzombie", "monster_zombie", "monster_headcrab", "monster_babycrab"}
ENT.HL2_Antlions = {"npc_antlion", "npc_antlionguard", "npc_antlion_worker"}

function VJ_TABLERANDOM(vtblname) return vtblname[math.random(1,table.Count(vtblname))] end
//function VJ_STOPSOUND(vsoundname) if vsoundname then vsoundname:Stop() end end

//util.AddNetworkString("vj_animal_onthememusic")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize() /* -- Example: self:SetCollisionBounds(Vector(50, 50, 100), Vector(-50, -50, 0)) */ end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSchedule() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ExpressionFinished(strExp) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(SoundData,SoundFile) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayEmitSound(SoundData) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTouch(entity) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnCondition(iCondition) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFollowPlayer(key,activator,caller,data) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPlayerSight(argent) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFootStepSound() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFootStepSound_Run() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFootStepSound_Walk() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWorldShakeOnMove() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWorldShakeOnMove_Run() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWorldShakeOnMove_Walk() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnCallForHelp() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFlinch_BeforeFlinch(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFlinch_AfterFlinch(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDamageByPlayer(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomWhenBecomingEnemyTowardsPlayer(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	return false -- Return to true if it gibbed!
	/*--------------------------------------
		-- Extra Features --
			Extra features allow you to have more control over the gibbing system.
			--/// Types \\\--
				AllowCorpse -- Should it allow corpse to spawn?
				DeathAnim -- Should it allow death animation?
			--/// Implementing it \\\--
				1. Let's use type DeathAnim as an example. NOTE: You can have as many types as you want!
				2. Put a comma next to return. 		===> return true,
				3. Make a table after the comma. 	===> return true, {}
				4. Put the type(s) that you want.	===> return true, {DeathAnim=true}
				5. And you are done!
				Example with multiple types:		===> return true, {DeathAnim=true,AllowCorpse=true}
	--------------------------------------*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo,hitgroup) return false end -- returning true will make the default gibbing sounds not play
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRareDropsOnDeathCode(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_BeforeCorpseSpawned(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetSpawnEffect(false)
	self:VJ_DoSelectDifficulty()
	self:SetModel(Model(VJ_PICKRANDOMTABLE(self.Model)))
	self:SetMaxYawSpeed(self.TurningSpeed)
	if self.HasHull == true then self:SetHullType(self.HullType) end
	if self.HullSizeNormal == true then self:SetHullSizeNormal() end
	self:SetCustomCollisionCheck()
	if self.HasSetSolid == true then self:SetSolid(SOLID_BBOX) end
	//self:SetMoveType(self.MoveType)
	self:DoChangeMovementType()
	if self.DisableInitializeCapabilities == false then self:SetInitializeCapabilities() end
	self:SetCollisionGroup(COLLISION_GROUP_NPC)
	self.NextIdleSoundT_RegularChange = CurTime() + math.random(0.1,3)
	if GetConVarNumber("vj_npc_allhealth") == 0 then
	if self.SelectedDifficulty == 0 then self:SetHealth(self.StartHealth/2) end -- Easy
	if self.SelectedDifficulty == 1 then self:SetHealth(self.StartHealth) end -- Normal
	if self.SelectedDifficulty == 2 then self:SetHealth(self.StartHealth*1.5) end -- Hard
	if self.SelectedDifficulty == 3 then self:SetHealth(self.StartHealth*2.5) end else -- Hell On Earth
	self:SetHealth(GetConVarNumber("vj_npc_allhealth")) end
	self.StartHealth = self:Health()
	self:SetName(self.PrintName)
	self:SetUseType(SIMPLE_USE)
	//self.Corpse = ents.Create(self.DeathCorpseEntityClass)
	if self.UseTheSameGeneralSoundPitch == true then self.UseTheSameGeneralSoundPitch_PickedNumber = math.random(self.GeneralSoundPitch1,self.GeneralSoundPitch2) end
	self:CustomOnInitialize()
	self:CustomInitialize() -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
	self:ConvarsOnInit()
	if math.random(1,self.SoundTrackChance) == 1 then self:StartSoundTrack() end
	self:SetRenderMode(RENDERMODE_NORMAL)
	//self:SetRenderMode(RENDERMODE_TRANSALPHA)
	duplicator.RegisterEntityClass(self:GetClass(),VJSPAWN_SNPC_DUPE,"Model","Class","Equipment","SpawnFlags","Data")
	//if self.Immune_Dissolve == true or self.GodMode == true then self:AddEFlags(EFL_NO_DISSOLVE) end
	self:AddEFlags(EFL_NO_DISSOLVE)
	if self.MovementType == VJ_MOVETYPE_GROUND then self:VJ_SetSchedule(SCHED_FALL_TO_GROUND) end
	/*if self.VJ_IsStationary == true then
		self.HasFootStepSound = false
		self.HasWorldShakeOnMove = false
		self.RunAwayOnUnknownDamage = false
		self.DisableWandering = true
		self.DisableChasingEnemy = true
	end*/
end
function ENT:CustomInitialize() end -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartUpTimers()
	self.NextIdleSoundT_RegularChange = CurTime() + math.random(0.1,3)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInitializeCapabilities()
-- Add as many as you want --
	//self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE)) -- Breaks some SNPCs, avoid using it!
	self:CapabilitiesAdd(bit.bor(CAP_TURN_HEAD))
	//if self.VJ_IsStationary == false then self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND)) end
	self:CapabilitiesAdd(bit.bor(CAP_OPEN_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_AUTO_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_USE))
	//self:CapabilitiesAdd(bit.bor(CAP_MOVE_JUMP))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoChangeMovementType(SetType)
	SetType = SetType or "None"
	if SetType != "None" then self.MovementType = SetType end
	if self.MovementType == VJ_MOVETYPE_GROUND then
		self:SetMoveType(MOVETYPE_STEP)
		self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND))
		if VJ_AnimationExists(self,ACT_JUMP) == true then self:CapabilitiesAdd(bit.bor(CAP_MOVE_JUMP)) end
		if VJ_AnimationExists(self,ACT_CLIMB_UP) == true && VJ_AnimationExists(self,ACT_CLIMB_DISMOUNT) == true then self:CapabilitiesAdd(bit.bor(CAP_MOVE_CLIMB)) end
		self:CapabilitiesRemove(CAP_MOVE_FLY)
		//self:CapabilitiesRemove(CAP_SKIP_NAV_GROUND_CHECK)
		self:CapabilitiesAdd(bit.bor(CAP_SKIP_NAV_GROUND_CHECK))
	end
	if self.MovementType == VJ_MOVETYPE_AERIAL then
		self:SetMoveType(MOVETYPE_FLY)
		self:CapabilitiesAdd(bit.bor(CAP_MOVE_FLY))
		self:CapabilitiesAdd(bit.bor(CAP_SKIP_NAV_GROUND_CHECK))
		self:CapabilitiesRemove(CAP_MOVE_GROUND)
		self:CapabilitiesRemove(CAP_MOVE_JUMP)
		self:CapabilitiesRemove(CAP_MOVE_CLIMB)
		self:CapabilitiesRemove(CAP_MOVE_SHOOT)
	end
	if self.MovementType == VJ_MOVETYPE_AQUATIC then
		self:SetMoveType(MOVETYPE_FLY)
		self:CapabilitiesAdd(bit.bor(CAP_MOVE_FLY))
		self:CapabilitiesAdd(bit.bor(CAP_SKIP_NAV_GROUND_CHECK))
		self:CapabilitiesRemove(CAP_MOVE_GROUND)
		self:CapabilitiesRemove(CAP_MOVE_JUMP)
		self:CapabilitiesRemove(CAP_MOVE_CLIMB)
		self:CapabilitiesRemove(CAP_MOVE_SHOOT)
	end
	if self.MovementType == VJ_MOVETYPE_STATIONARY then
		self:SetMoveType(MOVETYPE_NONE)
		self:CapabilitiesRemove(CAP_MOVE_GROUND)
		self:CapabilitiesRemove(CAP_MOVE_JUMP)
		self:CapabilitiesRemove(CAP_MOVE_CLIMB)
		self:CapabilitiesRemove(CAP_MOVE_SHOOT)
		self:CapabilitiesRemove(CAP_MOVE_FLY)
		self:CapabilitiesRemove(CAP_SKIP_NAV_GROUND_CHECK)
	end
	if self.MovementType == VJ_MOVETYPE_PHYSICS then
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:CapabilitiesRemove(CAP_MOVE_GROUND)
		self:CapabilitiesRemove(CAP_MOVE_JUMP)
		self:CapabilitiesRemove(CAP_MOVE_CLIMB)
		self:CapabilitiesRemove(CAP_MOVE_SHOOT)
		self:CapabilitiesRemove(CAP_MOVE_FLY)
		self:CapabilitiesRemove(CAP_SKIP_NAV_GROUND_CHECK)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoSchedule(schedule)
	self.LatestTaskName = schedule.Name
	if self:TaskFinished() then self:NextTask(schedule) end
	if self.CurrentTask then self:RunTask(self.CurrentTask) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTaskComplete()
	self.bTaskComplete = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_GOTO_TARGET() 
	local vsched = ai_vj_schedule.New("vj_act_followtarget")
	vsched:EngTask("TASK_GET_PATH_TO_TARGET", 0)
	vsched:EngTask("TASK_RUN_PATH", 0)
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_GOTO_PLAYER()
	local vsched = ai_vj_schedule.New("vj_act_gotoplayer")
	vsched:EngTask("TASK_GET_PATH_TO_PLAYER", 0)
	vsched:EngTask("TASK_RUN_PATH", 0)
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_ACT_PLAYACTIVITY(vACT_Name,vACT_StopActivities,vACT_StopActivitiesTime,vACT_DelayAnim,vACT_AdvancedFeatures,vACT_CustomCode)
	if vACT_Name == nil or vACT_Name == false then return end
	vACT_StopActivities = vACT_StopActivities or false
	vACT_StopActivitiesTime = vACT_StopActivitiesTime or 0
	vACT_DelayAnim = vACT_DelayAnim or 0
	vACT_AdvancedFeatures = vACT_AdvancedFeatures or {}
	vTbl_AlwaysUseSequence = vACT_AdvancedFeatures.AlwaysUseSequence or false
	vTbl_SequenceDuration = vACT_AdvancedFeatures.SequenceDuration -- Done automatically
	vTbl_SequenceInterruptible = vACT_AdvancedFeatures.SequenceInterruptible or false -- Can it be Interrupted? (Mostly used for idle animations)
	vTbl_AlwaysUseGesture = vACT_AdvancedFeatures.AlwaysUseGesture or false
	vTbl_PlayBackRate = vACT_AdvancedFeatures.PlayBackRate or 0.5
	//vACT_CustomCode = vACT_CustomCode or function() end
	if istable(vACT_Name) then vACT_Name = VJ_PICKRANDOMTABLE(vACT_Name) end
	local IsGesture = false
	local IsSequence = false
	if string.find(vACT_Name, "vjges_") then
		IsGesture = true
		vACT_Name = string.Replace(vACT_Name,"vjges_","") 
		if string.find(vACT_Name, "vjseq_") then
			IsSequence = true
			vACT_Name = string.Replace(vACT_Name,"vjseq_","")
		end
		if self:LookupSequence(vACT_Name) == -1 then vACT_Name = tonumber(vACT_Name) end
		//vACT_Name = tonumber(string.Replace(vACT_Name,"vjges_",""))
	end

	if type(vACT_Name) != "string" && VJ_AnimationExists(self,vACT_Name) == false then
		if self:GetActiveWeapon() != NULL then
			if table.HasValue(table.GetKeys(self:GetActiveWeapon().ActivityTranslateAI),vACT_Name) != true then return end
		else
			return
		end
	end
	if type(vACT_Name) == "string" && VJ_AnimationExists(self,vACT_Name) == false then return end
	
	local vsched = ai_vj_schedule.New("vj_act_"..vACT_Name)
	if vTbl_AlwaysUseSequence == true then
		IsSequence = true
		if type(vACT_Name) == "number" then
			vACT_Name = self:GetSequenceName(self:SelectWeightedSequence(vACT_Name))
		end
	end
	if vTbl_AlwaysUseGesture == true then
		IsGesture = true
		if type(vACT_Name) == "number" then
			vACT_Name = self:GetSequenceName(self:SelectWeightedSequence(vACT_Name))
		end
	end
	//vsched:EngTask("TASK_RESET_ACTIVITY", 0)
	if vACT_StopActivities == true then
		self.NextIdleTime = CurTime() + vACT_StopActivitiesTime
	end
	if (vACT_CustomCode) then vACT_CustomCode() end
	
	if vTbl_AlwaysUseSequence == false && type(vACT_Name) == "string" then
		local checkanim = self:GetSequenceActivity(self:LookupSequence(vACT_Name))
		if string.find(vACT_Name, "vjseq_") then
			IsSequence = true
			vACT_Name = string.Replace(vACT_Name,"vjseq_","")
		else
			if checkanim == nil or checkanim == -1 then
				IsSequence = true
			else
				vACT_Name = checkanim
			end
		end
	end
	if IsSequence == false then self.VJ_PlayingSequence = false end
	if self.VJ_IsPlayingInterruptSequence == true then self.VJ_IsPlayingInterruptSequence = false end
	
	timer.Simple(vACT_DelayAnim,function()
	if IsValid(self) then
		if IsGesture == true then
			local gesttest = false
			if IsSequence == false then gesttest = self:AddGesture(vACT_Name) end
			if IsSequence == true then gesttest = self:AddGestureSequence(vACT_Name) end
			if gesttest != false then
				self:SetLayerPriority(gesttest,2)
				self:SetLayerPlaybackRate(gesttest,vTbl_PlayBackRate)
				//self:SetLayerDuration(gesttest,3)
				//print(self:GetLayerDuration(gesttest))
			end
		end
		if IsSequence == true && IsGesture == false then
			seqwait = true
			if vTbl_SequenceDuration == false then seqwait = false end
			vTbl_SequenceDuration = vTbl_SequenceDuration or self:SequenceDuration(self:LookupSequence(vACT_Name))
			self:VJ_PlaySequence(vACT_Name,1,seqwait,vTbl_SequenceDuration,vTbl_SequenceInterruptible)
		end
		if IsGesture == false then
			//vsched:EngTask("TASK_RESET_ACTIVITY", 0)
			vsched:EngTask("TASK_STOP_MOVING", 0)
			vsched:EngTask("TASK_STOP_MOVING", 0)
			self:StopMoving()
			self:ClearSchedule()
			///self:ClearGoal()
			if IsSequence == false then
				self.VJ_PlayingSequence = false
				vsched:EngTask("TASK_PLAY_SEQUENCE",vACT_Name)
			end
			//self:ClearSchedule()
			//self:StartEngineTask(GetTaskList("TASK_RESET_ACTIVITY"), 0)
			self:StartSchedule(vsched)
			self:MaintainActivity()
		end
	 end
	end)
	//self:MaintainActivity()
	//self:TaskComplete()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_WANDER()
	local vsched = ai_vj_schedule.New("vj_act_idlewander")
	//self:SetLastPosition(self:GetPos() + self:GetForward() * 300)
	//vsched:EngTask("TASK_SET_ROUTE_SEARCH_TIME", 0)
	//vsched:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
	vsched:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 200)
	vsched:EngTask("TASK_WALK_PATH", 0)
	vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_IDLE_STAND(waittime)
	//if self.LatestTaskName == "vj_act_idlestand" then return end
	//local vsched = ai_vj_schedule.New("vj_act_idlestand")
	//vsched:EngTask("TASK_WAIT", waittime)
	//self:StartSchedule(vsched)
	//print(self:GetSequenceName(self:GetSequence()))
	//local idletbl = self.AnimTbl_IdleStand
	//if table.Count(idletbl) > 0 /*&& self:GetSequenceName(self:GetSequence()) != ideanimrand_act*/ then
	//	if VJ_IsCurrentAnimation(self,self.CurrentAnim_IdleStand) != true /*&& VJ_IsCurrentAnimation(self,ACT_IDLE) && self.VJ_PlayingSequence == false && self.VJ_IsPlayingInterruptSequence == false*/ then
	//		self.CurrentAnim_IdleStand = VJ_PICKRANDOMTABLE({idletbl})
	//		self:VJ_ACT_PLAYACTIVITY(self.CurrentAnim_IdleStand,false,0,true,0,{AlwaysUseSequence=true,SequenceDuration=false,SequenceInterruptible=true})
	//	end
	//else
		if self:IsCurrentSchedule(SCHED_IDLE_STAND) != true then
			self:VJ_SetSchedule(SCHED_IDLE_STAND)
		end
	//end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoCustomIdleAnimation()
	local idletbl = self.AnimTbl_IdleStand
	local idletblrand = VJ_PICKRANDOMTABLE(idletbl)
	if idletblrand == false then return end
	if self:GetActivity() == ACT_IDLE then
		if type(idletblrand) == "string" then
			local checkanim = self:GetSequenceActivity(self:LookupSequence(idletblrand))
			if checkanim == nil or checkanim == -1 then
				return false
			else
				idletblrand = checkanim
			end
		end
		self:StartEngineTask(GetTaskList("TASK_PLAY_SEQUENCE"), idletblrand)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoIdleAnimation(RestrictNumber,OverrideWander)
	if self.IsVJBaseSNPC_Tank == true then return end
	if self.VJ_PlayingSequence == true or self.FollowingPlayer == true or self.Dead == true or (self.NextIdleTime > CurTime()) then return end
	-- 0 = Random | 1 = Wander | 2 = Idle Stand /\ OverrideWander = Wander no matter what
	RestrictNumber = RestrictNumber or 0
	OverrideWander = OverrideWander or false
	if self.MovementType == VJ_MOVETYPE_STATIONARY then self:VJ_TASK_IDLE_STAND(math.Rand(6,12)) return end
	if OverrideWander == false && self.DisableWandering == true && (RestrictNumber == 1 or RestrictNumber == 0) then self:VJ_TASK_IDLE_STAND(math.Rand(2,4)) return end
	if RestrictNumber == 0 then
		if math.random(1,2) == 1 then
			self:VJ_SetSchedule(VJ_PICKRANDOMTABLE(self.IdleSchedule_Wander)) else self:VJ_TASK_IDLE_STAND(math.Rand(2,4))
		end
	end
	if RestrictNumber == 1 then
		self:VJ_SetSchedule(VJ_PICKRANDOMTABLE(self.IdleSchedule_Wander))
	end
	if RestrictNumber == 2 then
		self:VJ_TASK_IDLE_STAND(math.Rand(2,4))
	end
	self.NextIdleTime = CurTime() + math.random(2,6)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Touch(entity)
	if self.VJDEBUG_SNPC_ENABLED == true then if GetConVarNumber("vj_npc_printontouch") == 1 then print(self:GetClass().." Has Touched "..entity:GetClass()) end end
	self:CustomOnTouch(entity)
	if self.RunOnTouch == true && GetConVarNumber("ai_disabled") == 0 && self.VJ_IsBeingControlled == false && self.VJ_PlayingSequence == false then
	if CurTime() > self.NextRunOnTouchT then
	if entity:IsNPC() or entity:IsPlayer() then
	self:VJ_SetSchedule(SCHED_RUN_FROM_ENEMY) end
	self.NextRunOnTouchT = CurTime() + self.NextRunOnTouchTime end
	end
	if GetConVarNumber("ai_disabled") == 0 then
	if CurTime() > self.NextOnTouchFearSoundT then
		if self.PlayAlertSoundOnlyOnce == true then
			if self.HasDone_PlayAlertSoundOnlyOnce == false then
			self:AlertSoundCode() 
			self.HasDone_PlayAlertSoundOnlyOnce = true end
		else
			self:AlertSoundCode()
		end
	self.NextOnTouchFearSoundT = CurTime() + self.NextOnTouchFearSoundTime end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AcceptInput(key,activator,caller,data)
	self:CustomOnAcceptInput(key,activator,caller,data)
	self:FollowPlayerCode(key,activator,caller,data)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCondition(iCondition)
	self:CustomOnCondition(iCondition)
	//if iCondition == 36 then print("sched done!") end
	//print(self," Condition: ",iCondition," - ",self:ConditionName(iCondition))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FollowPlayerReset()
	if self.FollowPlayerChat == true then
	self.FollowingPlayerName:PrintMessage(HUD_PRINTTALK, self:GetName().." is no longer following you.") end
	self.FollowingPlayer = false
	self.DontStartShooting_FollowPlayer = false
	self.FollowingPlayerName = NULL
	self.DisableWandering = self.FollowingPlayer_WanderValue
	self.DisableChasingEnemy = self.FollowingPlayer_ChaseValue
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FollowPlayerCode(key,activator,caller,data)
	if self.FollowPlayer == false or  GetConVarNumber("ai_disabled") == 1 or GetConVarNumber("ai_ignoreplayers") == 1 then return end
	if key == self.FollowPlayerKey && activator:IsValid() && activator:Alive() && activator:IsPlayer() then
		if self:Disposition(activator) == D_HT then
			if self.FollowPlayerChat == true then
				activator:PrintMessage(HUD_PRINTTALK, self:GetName().." doesn't like you, therefore it won't follow you.")
			end
			return
		end
		self:CustomOnFollowPlayer(key,activator,caller,data)
		if self.FollowingPlayer == false then
			//self:FaceCertainEntity(activator,false)
			if self.FollowPlayerChat == true then
			activator:PrintMessage(HUD_PRINTTALK, self:GetName().." is now following you.") end
			self.FollowingPlayer_WanderValue = self.DisableWandering
			self.FollowingPlayer_ChaseValue = self.DisableChasingEnemy
			self.DisableWandering = true
			self.DisableChasingEnemy = true
			self:SetTarget(activator)
			self.FollowingPlayerName = activator
			self:StopMoving()
			timer.Simple(0.15,function() if self:IsValid() && self.VJ_PlayingSequence == false then self:VJ_SetSchedule(SCHED_TARGET_FACE) end end)
			//if self.VJ_PlayingSequence == false then self:VJ_SetSchedule(SCHED_IDLE_STAND) end
			timer.Simple(0.1,function() if self:IsValid() then self:VJ_TASK_GOTO_TARGET() end end)
			self:FollowPlayerSoundCode()
			self.FollowingPlayer = true 
		else
			self:UnFollowPlayerSoundCode()
			if self.VJ_PlayingSequence == false then self:VJ_SetSchedule(SCHED_TARGET_FACE) end
			self:FollowPlayerReset()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	//if self:IsFlagSet(FL_FLY) then print("It has flag FLY set") end
	//print(self:GetSequence())
	//self:ConvarsOnThink()
	self:CustomOnThink()
	
	if self.HasEntitiesToNoCollide == true then self:EntitiesToNoCollideCode() end -- Collison between something

	if self.HasSounds == false or self.Dead == true then VJ_STOPSOUND(self.CurrentBreathSound) end
	if self.Dead == false && self.HasBreathSound == true && self.HasSounds == true then
		if CurTime() > self.NextBreathSoundT then
			self.CurrentBreathSound = VJ_CreateSound(self,self.SoundTbl_Breath,self.BreathSoundLevel,self:VJ_DecideSoundPitch(self.BreathSoundPitch1,self.BreathSoundPitch2))
			self.NextBreathSoundT = CurTime() + math.Rand(self.NextSoundTime_Breath1,self.NextSoundTime_Breath2)
		end
	end
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
if GetConVarNumber("ai_disabled") == 0 then
	self:CustomOnThink_AIEnabled()
	self:DoCustomIdleAnimation()
	if self.VJDEBUG_SNPC_ENABLED == true then
		if GetConVarNumber("vj_npc_printenemyclass") == 1 then
		if self:GetEnemy() != nil then print(self:GetClass().."'s Enemy: "..self:GetEnemy():GetClass()) else print(self:GetClass().."'s Enemy: None") end end
		if GetConVarNumber("vj_npc_printseenenemy") == 1 then
		if self:GetEnemy() != nil then print(self:GetClass().." Has Seen an Enemy!") else print(self:GetClass().." Has NOT Seen an Enemy!") end end
		if GetConVarNumber("vj_npc_printtakingcover") == 1 then
		if self.TakingCover == true then print(self:GetClass().." Is Taking Cover") else print(self:GetClass().." Is Not Taking Cover") end end
	end
	
	self:IdleSoundCode()
	if self.DisableFootStepSoundTimer == false then self:FootStepSoundCode() end
	self:WorldShakeOnMoveCode()
	
if self.FollowingPlayer == true then
	//print(self:GetTarget())
	//print(self.FollowingPlayerName)
	if GetConVarNumber("ai_ignoreplayers") == 0 then
	if !self.FollowingPlayerName:Alive() then self:FollowPlayerReset() end
	if CurTime() > self.NextFollowPlayerT && IsValid(self.FollowingPlayerName) && self.FollowingPlayerName:Alive() && self.AlreadyBeingHealedByMedic == false then
		local DistanceToPly = self:GetPos():Distance(self.FollowingPlayerName:GetPos())
		self:SetTarget(self.FollowingPlayerName)
		//print(DistanceToPly)
		if DistanceToPly > self.FollowPlayerCloseDistance then
			self.DontStartShooting_FollowPlayer = true
			self:VJ_TASK_GOTO_TARGET()
		else
			self:StopMoving()
			self.DontStartShooting_FollowPlayer = false
		end
		self.NextFollowPlayerT = CurTime() + self.NextFollowPlayerTime
		end
	else
		self:FollowPlayerReset()
	end
end
	
	//if self.CombineFriendly == true then self:CombineFriendlyCode() end
	//if self.ZombieFriendly == true then self:ZombieFriendlyCode() end
	//if self.AntlionFriendly == true then self:AntlionFriendlyCode() end
	//if self.PlayerFriendly == true then self:PlayerAllies() end
	//if self.FriendlyToVJSNPCs == true or GetConVarNumber("vj_npc_vjfriendly") == 1 then self:VJFriendlyCode() end
	if self.HasOnPlayerSight == true then self:OnPlayerSightCode() end
	
	/*local frianimals = self.HL2_Animals
	table.Add(frianimals)
	for _,x in pairs( frianimals ) do
		local hl_friendlys = ents.FindByClass( x )
		for _,x in pairs( hl_friendlys ) do
		x:AddEntityRelationship( self, 3, 10 )
	  end
	end*/
		//end
 end
 self:NextThink(CurTime() +0.1)
 return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SelectSchedule()
if self.VJ_IsBeingControlled == true then return end
self:CustomOnSchedule()
if self.DisableSelectSchedule == true then return end
	//local MyNearbyTargets = ents.FindInSphere(self:GetPos(),self:GetForward(),100,100)
	//if (!MyNearbyTargets) then return end
	//for k,v in pairs(MyNearbyTargets) do
	//self:VJ_SetSchedule(SCHED_FORCED_GO_RUN)
//end
	self:DoIdleAnimation()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayerSightCode()
	if self.HasOnPlayerSight == false then return end
	if self.OnPlayerSightOnlyOnce == true then if self.OnPlayerSight_AlreadySeen == true then return end end
	if GetConVarNumber("ai_ignoreplayers") == 1 then return end
	local PlayerTargets = VJ_FindInCone(self:GetPos(),self:GetForward(),self.OnPlayerSightDistance,self.SightAngle)
	if (!PlayerTargets) then return end
	for k,argent in pairs(PlayerTargets) do
		if (CurTime() > self.OnPlayerSightNextT) && (self:Visible(argent)) && (self:GetForward():Dot((argent:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.SightAngle))) then
			if self.OnPlayerSightDispositionLevel == 1 && self:Disposition(argent) != D_LI && self:Disposition(argent) != D_NU then return end
			if self.OnPlayerSightDispositionLevel == 2 && (self:Disposition(argent) == D_LI or self:Disposition(argent) == D_NU) then return end
			self:CustomOnPlayerSight(argent)
			self.OnPlayerSight_AlreadySeen = true
			self:OnPlayerSightSoundCode()
			if self.OnPlayerSightOnlyOnce == false then self.OnPlayerSightNextT = CurTime() + math.Rand(self.OnPlayerSightNextTime1,self.OnPlayerSightNextTime2) end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DamageByPlayerCode(dmginfo,hitgroup)
	if self.HasDamageByPlayer == true && CurTime() > self.NextDamageByPlayerT && GetConVarNumber("ai_disabled") == 0 then
		local theattack = dmginfo:GetAttacker()
		if theattack:IsPlayer() && (self:Visible(theattack)) then
			if self.DamageByPlayerDispositionLevel == 1 && self:Disposition(theattack) != D_LI && self:Disposition(theattack) != D_NU then return end
			if self.DamageByPlayerDispositionLevel == 2 && (self:Disposition(theattack) == D_LI or self:Disposition(theattack) == D_NU) then return end
			self:CustomOnDamageByPlayer(dmginfo,hitgroup)
			self:DamageByPlayerSoundCode()
			self.NextDamageByPlayerT = CurTime() + math.Rand(self.DamageByPlayerNextTime1,self.DamageByPlayerNextTime2)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJFriendlyCode(argent)
	if self.HasAllies == false or GetConVarNumber("vj_npc_vjfriendly") == 0 then return false end
	argent:AddEntityRelationship(self,D_LI,99)
	self:AddEntityRelationship(argent,D_LI,99)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CombineFriendlyCode(argent)
	if self.HasAllies == false then return end
	if table.HasValue(self.HL2_Combine,argent:GetClass()) then
		argent:AddEntityRelationship(self,D_LI,99)
		self:AddEntityRelationship(argent,D_LI,99)
		return true 
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieFriendlyCode(argent)
	if self.HasAllies == false then return end
	if table.HasValue(self.HL2_Zombies,argent:GetClass()) then
		argent:AddEntityRelationship(self,D_LI,99)
		self:AddEntityRelationship(argent,D_LI,99)
		return true 
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AntlionFriendlyCode(argent)
	if self.HasAllies == false then return end
	if table.HasValue(self.HL2_Antlions,argent:GetClass()) then
		argent:AddEntityRelationship(self,D_LI,99)
		self:AddEntityRelationship(argent,D_LI,99)
		return true 
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayerAllies(argent)
	if self.HasAllies == false then return end
	if table.HasValue(self.HL2_Resistance,argent:GetClass()) then
		argent:AddEntityRelationship(self,D_LI,99)
		self:AddEntityRelationship(argent,D_LI,99)
		return true 
	end
	return false
end
--------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:GetRelationship(entity)
	if self.HasAllies == false then return end
	
	local friendslist = {"", "", "", "", "", ""} -- List
	for _,x in pairs( friendslist ) do
	local hl_friendlys = ents.FindByClass( x )
	for _,x in pairs( hl_friendlys ) do
	if entity == x then
	return D_LI
	end
  end
 end
 
	local groupone = ents.FindByClass("npc_vj_example_*") -- Group
	table.Add(groupone)
	for _, x in pairs(groupone) do
	if entity == x then
	return D_LI
	end
 end
 
	local groupone = ents.FindByClass("npc_vj_example") -- Single
	for _, x in pairs(groupone) do
	if entity == x then
	return D_LI
	end
 end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckAlliesAroundMe(SeeDistance)
	SeeDistance = SeeDistance or 800
	local FoundEntitiesTbl = {}
	local getselfclass = ents.FindInSphere(self:GetPos(),SeeDistance)
	if (!getselfclass) then return end
	for _,x in pairs(getselfclass) do
		if (x:IsNPC() or x:GetClass() == self:GetClass()) && x != self /*&& x:GetClass() == self:GetClass()*/ && x:Disposition(self) != 1 && x:Disposition(self) != 2 && (x:GetClass() == self:GetClass() or x:Disposition(self) != 4) && VJ_IsAlive(x) == true && x.IsVJBaseSNPC_Animal != false then
			if x.BringFriendsOnDeath == true or x.CallForBackUpOnDamage == true or x.CallForHelp == true then
				table.insert(FoundEntitiesTbl,x)
				//print(x:GetClass())
			end
		end
	end
	if table.Count(FoundEntitiesTbl) > 0 then
		return {ItFoundAllies = true, FoundAllies = FoundEntitiesTbl} 
	else
		return {ItFoundAllies = false, FoundAllies = nil}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BringAlliesToMe(SeeDistance,CertainAmount,CertainAmountNumber,EnemyVisibleOnly)
	//if self.CallForBackUpOnDamage == false then return end
	SeeDistance = SeeDistance or 800
	EnemyVisibleOnly = EnemyVisibleOnly or false
	CertainAmountNumber = CertainAmountNumber or 3
	local getselfclass = ents.FindInSphere(self:GetPos(),SeeDistance)
	local LocalTargetTable = {}
	if (!getselfclass) then return end
	for _,x in pairs(getselfclass) do
	if VJ_IsAlive(x) == true && x:IsNPC() && x != self /*&& x:GetClass() == self:GetClass()*/ && x:Disposition(self) != 1 && x:Disposition(self) != 2 && x.IsVJBaseSNPC_Animal == true && x.FollowingPlayer == false && x.VJ_IsBeingControlled == false && (!x.IsVJBaseSNPC_Tank) then
	if x.BringFriendsOnDeath == true or x.CallForBackUpOnDamage == true or x.CallForHelp == true then
	if EnemyVisibleOnly == true then if x:Visible(self) == false then continue end end
	table.insert(LocalTargetTable,x)
	if x:GetEnemy() == nil then
	if self:GetPos():Distance(x:GetPos()) < SeeDistance then
	//print(table.ToString(LocalTargetTable,"stupid table",true)) //end
	local randompostogo = math.random(1,4)
		if randompostogo == 1 then x:SetLastPosition(self:GetPos() + self:GetRight()*math.random(20,50)) else
		if randompostogo == 2 then x:SetLastPosition(self:GetPos() + self:GetRight()*math.random(-20,-50)) end
		if randompostogo == 3 then x:SetLastPosition(self:GetPos() + self:GetForward()*math.random(20,50)) end
		if randompostogo == 4 then x:SetLastPosition(self:GetPos() + self:GetForward()*math.random(-20,-50)) end
	end
	if x.VJ_PlayingSequence == false then
	local randommovesched = math.random(1,2)
	if randommovesched == 1 then x:VJ_SetSchedule(self.BringFriendsToMeSCHED1) end
	if randommovesched == 2 then x:VJ_SetSchedule(self.BringFriendsToMeSCHED2) end
	//return true -- It will only pick one if returning false or true
	 end
	end
   end
   if CertainAmount == true then
   if table.Count(LocalTargetTable) == CertainAmountNumber then 
   return true end
	end
   end
  end
 end
 //print(table.ToString(LocalTargetTable,"stupid table",true))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo,hitgroup)
	if self.DoingVJDeathDissolve == true then self.DoingVJDeathDissolve = false return true end
	if self.Dead == true then return false end
	if self.GodMode == true then return false end
	if dmginfo:GetDamage() <= 0 then return false end
	
	local DamageInflictor = dmginfo:GetInflictor()
	if IsValid(DamageInflictor) then local DamageInflictorClass = DamageInflictor:GetClass() end
	local DamageAttacker = dmginfo:GetAttacker()
	if IsValid(DamageAttacker) then local DamageAttackerClass = DamageAttacker:GetClass() end
	local DamageType = dmginfo:GetDamageType()
	local hitgroup = self.VJ_ScaleHitGroupDamage
	self:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo,hitgroup)
	
	if self.GetDamageFromIsHugeMonster == true then
		if DamageAttacker.VJ_IsHugeMonster == true then
			self:SetHealth(self:Health() -dmginfo:GetDamage())
		end
		if self:Health() <= 0 && self.Dead == false then
			self:PriorToKilled(dmginfo,hitgroup)
		end
	end

	if (self:IsOnFire()) && self:WaterLevel() == 3 then self:Extinguish() end

	if table.HasValue(self.ImmuneDamagesTable,DamageType) then return end
	if self.AllowIgnition == false && self:IsOnFire() then self:Extinguish() return false end
	if self.Immune_Bullet == true && (dmginfo:IsBulletDamage() or DamageType == DMG_AIRBOAT or DamageType == DMG_BUCKSHOT) then return false end
	if self.Immune_Physics == true && DamageType == DMG_CRUSH then return false end
	if self.Immune_Blast == true && DamageType == DMG_BLAST then return false end
	if self.Immune_Freeze == true && (DamageType == DMG_SLOWFREEZE or DamageType == DMG_FREEZE) then return false end
	if self.Immune_Electricity == true && (DamageType == DMG_SHOCK or DamageType == DMG_SONIC or DamageType == DMG_ENERGYBEAM or DamageType == DMG_PHYSGUN) then return false end
	if self.Immune_AcidPoisonRadiation == true && (DamageType == DMG_ACID or DamageType == DMG_RADIATION or DamageType == DMG_POISON or DamageType == DMG_NERVEGAS or DamageType == DMG_PARALYZE) then return false end
	if self.Immune_Dissolve == true then if DamageType == DMG_DISSOLVE then return false end end
	if ((IsValid(DamageInflictor) && DamageInflictorClass == "prop_combine_ball") or (IsValid(DamageAttacker) && DamageAttackerClass == "prop_combine_ball")) then
		if self.Immune_Dissolve == true then return false end
		if CurTime() > self.NextCanGetCombineBallDamageT then
			dmginfo:SetDamage(math.random(400,500))
			dmginfo:SetDamageType(DMG_DISSOLVE)
			self.NextCanGetCombineBallDamageT = CurTime() + 0.2
		else
			dmginfo:SetDamage(1)
		end
	end

	self:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if dmginfo:GetDamage() <= 0 then return false end
	self:SetHealth(self:Health() -dmginfo:GetDamage())
	if self.VJDEBUG_SNPC_ENABLED == true then if GetConVarNumber("vj_npc_printondamage") == 1 then print(self:GetClass().." Got Damaged! | Amount = "..dmginfo:GetDamage()) end end
	self:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup)
	if self.Bleeds == true && dmginfo:GetDamage() > 0 then
		self:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
		if self.HasBloodParticle == true then self:SpawnBloodParticles(dmginfo,hitgroup) end
		if self.HasBloodDecal == true then self:SpawnBloodDecal(dmginfo,hitgroup) end
		self:ImpactSoundCode()
	end

	if self:Health() >= 0 then
		self:DoFlinch(dmginfo,hitgroup)
		self:DamageByPlayerCode(dmginfo,hitgroup)
		self:PainSoundCode()
		
		if self.CallForBackUpOnDamage == true && CurTime() > self.NextCallForBackUpOnDamageT && self:GetEnemy() == nil && self.FollowingPlayer == false && self:CheckAlliesAroundMe(self.CallForBackUpOnDamageDistance).ItFoundAllies == true then
			self:BringAlliesToMe(self.CallForBackUpOnDamageDistance,self.CallForBackUpOnDamageUseCertainAmount,self.CallForBackUpOnDamageUseCertainAmountNumber)
			self:ClearSchedule()
			//self.TakingCover = true
			self.NextFlinchT = CurTime() + 1
			self.CurrentAnim_CallForBackUpOnDamage = VJ_PICKRANDOMTABLE(self.CallForBackUpOnDamageAnimation)
			if VJ_AnimationExists(self,self.CurrentAnim_CallForBackUpOnDamage) == true && self.DisableCallForBackUpOnDamageAnimation == false then
				self:VJ_ACT_PLAYACTIVITY(self.CurrentAnim_CallForBackUpOnDamage,true,self.CallForBackUpOnDamageAnimationTime,true)
			else
				self:VJ_SetSchedule(SCHED_RUN_FROM_ENEMY)
				/*local vschedHide = ai_vj_schedule.New("vj_hide_callbackupondamage")
				vschedHide:EngTask("TASK_FIND_COVER_FROM_ENEMY", 0)
				vschedHide:EngTask("TASK_RUN_PATH", 0)
				vschedHide:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
				vschedHide.ResetOnFail = true
				self:StartSchedule(vschedHide)*/
			end
			self.NextCallForBackUpOnDamageT = CurTime() + math.Rand(self.NextCallForBackUpOnDamageTime1,self.NextCallForBackUpOnDamageTime2)
		end
		
		if self.BecomeEnemyToPlayer == true && DamageAttacker:IsPlayer() && GetConVarNumber("ai_disabled") == 0 && GetConVarNumber("ai_ignoreplayers") == 0 && (self:Disposition(DamageAttacker) == D_LI or self:Disposition(DamageAttacker) == D_NU) then
			if self.AngerLevelTowardsPlayer <= self.BecomeEnemyToPlayerLevel then
			self.AngerLevelTowardsPlayer = self.AngerLevelTowardsPlayer + 1 end
			if self.AngerLevelTowardsPlayer > self.BecomeEnemyToPlayerLevel then
			if self:Disposition(DamageAttacker) != D_HT then
			self:CustomWhenBecomingEnemyTowardsPlayer(dmginfo,hitgroup)
			if self.FollowingPlayer == true then self:FollowPlayerReset() end
			table.insert(self.VJ_AddCertainEntityAsEnemy,dmginfo:GetAttacker())
			if GetConVarNumber("vj_npc_nosnpcchat") == 0 then
			dmginfo:GetAttacker():PrintMessage(HUD_PRINTTALK, self:GetName().." no longer likes you.") end
			self:BecomeEnemyToPlayerSoundCode() end
			//self.NoLongerLikesThePlayer = true
			self.Alerted = true
			if self.BecomeEnemyToPlayerSetPlayerFriendlyFalse == true then
			/*self.PlayerFriendly = false*/ end
			end
		end

		if self.TakingCover == false && self.VJ_IsBeingControlled == false && self.FollowingPlayer == false && self.VJ_PlayingSequence == false && self.RunAwayOnUnknownDamage == true && self.MovementType != VJ_MOVETYPE_STATIONARY then
			if CurTime() > self.NextRunAwayOnDamageT then
			self:VJ_SetSchedule(SCHED_RUN_FROM_ENEMY) end
			self.NextRunAwayOnDamageT = CurTime() + self.NextRunAwayOnDamageTime
		end
	end

	if self:Health() <= 0 && self.Dead == false then
		self:RemoveEFlags(EFL_NO_DISSOLVE)
		if (dmginfo:GetDamageType() == DMG_DISSOLVE) or (IsValid(dmginfo:GetInflictor()) && dmginfo:GetInflictor():GetClass() == "prop_combine_ball") then
			local dissolve = DamageInfo()
			dissolve:SetDamage(self:Health())
			dissolve:SetAttacker(dmginfo:GetAttacker())
			dissolve:SetDamageType(DMG_DISSOLVE)
			self.DoingVJDeathDissolve = true
			self:TakeDamageInfo(dissolve)
		end
		self:PriorToKilled(dmginfo,hitgroup)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoFlinch(dmginfo,hitgroup)
	if self.CanFlinch == 0 or self.Flinching == true or (self.NextFlinchT > CurTime()) then return end
	
	local function RunFlinchCode(HitBoxBased,HitBoxInfo)
		self.Flinching = true
		self:StopAttacks(true)
		if HitBoxBased == true then
			self.CurrentFlinchAnimation = VJ_PICKRANDOMTABLE(HitBoxInfo.Animation)
			self.CurrentFlinchAnimationDuration = VJ_GetSequenceDuration(self,self.CurrentFlinchAnimation) -self.FlinchAnimationDecreaseLengthAmount
			if self.NextMoveAfterFlinchTime != "LetBaseDecide" then self.CurrentFlinchAnimationDuration = self.NextMoveAfterFlinchTime end
			if self.NextMoveAfterFlinchTime == "LetBaseDecide" && HitBoxInfo.IsSchedule == true then self.CurrentFlinchAnimationDuration = 0.6 end
			if HitBoxInfo.IsSchedule == true then 
				self:VJ_SetSchedule(VJ_PICKRANDOMTABLE(self.CurrentFlinchAnimation)) 
			else
				self:VJ_ACT_PLAYACTIVITY(self.CurrentFlinchAnimation,false,0,false,0,{SequenceDuration=self.CurrentFlinchAnimationDuration})
			end
		else
			if self.FlinchAnimation_UseSchedule == true then self.CurrentFlinchAnimation = VJ_PICKRANDOMTABLE(self.ScheduleTbl_Flinch) else self.CurrentFlinchAnimation = VJ_PICKRANDOMTABLE(self.AnimTbl_Flinch) end
			self.CurrentFlinchAnimationDuration = VJ_GetSequenceDuration(self,self.CurrentFlinchAnimation) -self.FlinchAnimationDecreaseLengthAmount
			if self.NextMoveAfterFlinchTime != "LetBaseDecide" then self.CurrentFlinchAnimationDuration = self.NextMoveAfterFlinchTime end
			if self.NextMoveAfterFlinchTime == "LetBaseDecide" && self.FlinchAnimation_UseSchedule == true then self.CurrentFlinchAnimationDuration = 0.6 end
			if self.FlinchAnimation_UseSchedule == true then
				self:VJ_SetSchedule(VJ_PICKRANDOMTABLE(self.CurrentFlinchAnimation))
			else
				self:VJ_ACT_PLAYACTIVITY(self.CurrentFlinchAnimation,false,0,false,0,{SequenceDuration=self.CurrentFlinchAnimationDuration})
			end
		end
		timer.Simple(self.CurrentFlinchAnimationDuration,function() if IsValid(self) then self.Flinching = false if self:GetEnemy() != nil then self:DoChaseAnimation() else self:DoIdleAnimation() end end end)
		self:CustomOnFlinch_AfterFlinch(dmginfo,hitgroup)
		self.NextFlinchT = CurTime() + self.NextFlinchTime
	end
	
	local randflinch = math.random(1,self.FlinchChance)
	if randflinch == 1 then
		if (self.CanFlinch == 2 && table.HasValue(self.FlinchDamageTypes,dmginfo:GetDamageType())) or (self.CanFlinch == 1) then
			self:CustomOnFlinch_BeforeFlinch(dmginfo,hitgroup)
			if self.HasHitGroupFlinching == true then
				local HitGroupFound = false
				for k,v in ipairs(self.HitGroupFlinching_Values) do
					if table.HasValue(v.HitGroup,hitgroup) then
					//if v.HitGroup == hitgroup then
						HitGroupFound = true
						RunFlinchCode(true,v)
					end
				end
				if HitGroupFound == false && self.HitGroupFlinching_DefaultWhenNotHit == true then
					RunFlinchCode(false)
				end
			else
				RunFlinchCode(false)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodDecal(dmginfo,hitgroup)
	local DamageForce = dmginfo:GetDamageForce()
	local DamagePos = dmginfo:GetDamagePosition()
	local length = math.Clamp(DamageForce:Length() *10, 100, self.BloodDecalDistance)
	local paintit = tobool(math.random(10, math.Round(length *0.125)) <= self.BloodDecalRate)
	if !paintit then return end
	local posEnd = DamagePos +DamageForce:GetNormal() *length
	local tr = util.TraceLine({start = DamagePos, endpos = posEnd, filter = self})
	//if !tr.HitWorld then return end
	util.Decal(VJ_PICKRANDOMTABLE(self.BloodDecal),tr.HitPos +tr.HitNormal,tr.HitPos -tr.HitNormal)
	if math.random(1,2) == 1 then util.Decal(VJ_PICKRANDOMTABLE(self.BloodDecal),tr.HitPos +tr.HitNormal +Vector(0,math.random(-100,100),0),tr.HitPos -tr.HitNormal) end
	if math.random(1,2) == 1 then util.Decal(VJ_PICKRANDOMTABLE(self.BloodDecal),tr.HitPos +tr.HitNormal +Vector(math.random(-100,100),0,0),tr.HitPos -tr.HitNormal) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodParticles(dmginfo,hitgroup)
	local DamageType = dmginfo:GetDamageType()
	local DamagePos = dmginfo:GetDamagePosition()
	if DamagePos == Vector(0,0,0) then DamagePos = self:GetPos() + self:OBBCenter() end
	//if DamageType == DMG_ACID or DamageType == DMG_RADIATION or DamageType == DMG_POISON or DamageType == DMG_CRUSH or DamageType == DMG_SLASH or DamageType == DMG_GENERIC or self:IsOnFire() then DoUnPositionedParticle() return false end

	local bloodeffect = ents.Create("info_particle_system")
	bloodeffect:SetKeyValue("effect_name",VJ_PICKRANDOMTABLE(self.BloodParticle))
	bloodeffect:SetPos(DamagePos) 
	bloodeffect:Spawn()
	bloodeffect:Activate() 
	bloodeffect:Fire("Start","",0)
	bloodeffect:Fire("Kill","",0.1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PriorToKilled(dmginfo,hitgroup)
	if self.BringFriendsOnDeath == true then
		self:BringAlliesToMe(self.BringFriendsOnDeathDistance,self.BringFriendsOnDeathUseCertainAmount,self.BringFriendsOnDeathUseCertainAmountNumber,true)
	end

	local function DoKilled()
		if IsValid(self) then
			if self.WaitBeforeDeathTime == 0 then 
				self:OnKilled(dmginfo,hitgroup) 
			else
				timer.Simple(self.WaitBeforeDeathTime,function() if IsValid(self) then self:OnKilled(dmginfo,hitgroup) end end)
			end
		end
	end

	-- Blood decal on the ground
	if self.Bleeds == true && self.HasBloodDecal == true then
		self:SetLocalPos(Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z +4)) -- Because the NPC is too close to the ground
		local tr = util.TraceLine({
			start = self:GetPos(),
			endpos = self:GetPos() - Vector(0, 0, 500),
			filter = self //function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
		})
		util.Decal(VJ_PICKRANDOMTABLE(self.BloodDecal),tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
	end

	self.Dead = true
	self:StopAllCommonSounds()
	self:DeathNotice_PlayerPoints(dmginfo,hitgroup)
	self:CustomOnPriorToKilled(dmginfo,hitgroup)
	self:SetCollisionGroup(1)
	self:RunGibOnDeathCode(dmginfo,hitgroup)
	self:DeathSoundCode()
	if self.HasDeathAnimation != true then DoKilled() return end
	if self.HasDeathAnimation == true then
		if GetConVarNumber("vj_npc_nodeathanimation") == 1 or GetConVarNumber("ai_disabled") == 1 or ((dmginfo:GetDamageType() == DMG_DISSOLVE) or (IsValid(dmginfo:GetInflictor()) && dmginfo:GetInflictor():GetClass() == "prop_combine_ball")) then DoKilled() return end
			if (dmginfo:GetDamageType() != DMG_DISSOLVE) && (IsValid(dmginfo:GetInflictor()) && dmginfo:GetInflictor():GetClass() != "prop_combine_ball") then
			local randanim = math.random(1,self.DeathAnimationChance)
			if randanim != 1 then DoKilled() return end
			if randanim == 1 then
				self:CustomDeathAnimationCode(dmginfo,hitgroup)
				self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(self.AnimTbl_Death),true,self.DeathAnimationTime,false,0,{SequenceDuration=self.DeathAnimationTime})
				self.DeathAnimationCodeRan = true
				timer.Simple(self.DeathAnimationTime,DoKilled)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunGibOnDeathCode(dmginfo,hitgroup)
	if self.AllowedToGib == false or self.HasGibOnDeath == false or self.HasBeenGibbedOnDeath == true then return end
	local DamageType = dmginfo:GetDamageType()
	local dmgtbl = self.GibOnDeathDamagesTable
	local dmgtblempty = false
	local usedefault = false
	local defualtdmgs = {DMG_BLAST,DMG_VEHICLE,DMG_CRUSH,DMG_DIRECT,DMG_DISSOLVE,DMG_AIRBOAT,DMG_SLOWBURN,DMG_PHYSGUN,DMG_PLASMA,DMG_SHOCK,DMG_SONIC}
	if table.HasValue(self.GibOnDeathDamagesTable,"UseDefault") then usedefault = true end
	if usedefault == false && (table.Count(dmgtbl) <= 0 or table.HasValue(self.GibOnDeathDamagesTable,"All")) then dmgtblempty = true end
	if (dmgtblempty == true) or (usedefault == true && table.HasValue(defualtdmgs,DamageType)) or (usedefault == false && table.HasValue(dmgtbl,DamageType)) then
		local setupgib, setupgib_extra = self:SetUpGibesOnDeath(dmginfo,hitgroup)
		if setupgib_extra == nil then setupgib_extra = {} end
		if setupgib == true then
			if setupgib_extra.AllowCorpse != true then self.HasDeathRagdoll = false end
			if setupgib_extra.DeathAnim != true then self.HasDeathAnimation = false end
			self.HasBeenGibbedOnDeath = true
			self:PlayGibOnDeathSounds(dmginfo,hitgroup)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayGibOnDeathSounds(dmginfo,hitgroup)
	if self.HasGibOnDeathSounds == false then return end
	local custom = self:CustomGibOnDeathSounds(dmginfo,hitgroup)
	if custom == false then
		VJ_EmitSound(self,"vj_gib/default_gib_splat.wav",90,math.random(80,100))
		VJ_EmitSound(self,"vj_gib/gibbing1.wav",90,math.random(80,100))
		VJ_EmitSound(self,"vj_gib/gibbing2.wav",90,math.random(80,100))
		VJ_EmitSound(self,"vj_gib/gibbing3.wav",90,math.random(80,100))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateGibEntity(Ent,Models,Tbl_Features,CustomCode)
	// self:CreateGibEntity("prop_ragdoll","",{Pos=self:LocalToWorld(Vector(0,3,0)),Ang=self:GetAngles(),Vel=})
	if self.AllowedToGib == false then return end
	Ent = Ent or "prop_ragdoll"
	if Models == "UseAlien_Small" then Models = {"models/gibs/xenians/sgib_01.mdl","models/gibs/xenians/sgib_02.mdl","models/gibs/xenians/sgib_03.mdl"} end
	if Models == "UseAlien_Big" then Models = {"models/gibs/xenians/mgib_01.mdl","models/gibs/xenians/mgib_02.mdl","models/gibs/xenians/mgib_03.mdl","models/gibs/xenians/mgib_04.mdl","models/gibs/xenians/mgib_05.mdl","models/gibs/xenians/mgib_06.mdl","models/gibs/xenians/mgib_07.mdl"} end
	if Models == "UseHuman_Small" then Models = {"models/gibs/humans/sgib_01.mdl","models/gibs/humans/sgib_02.mdl","models/gibs/humans/sgib_03.mdl"} end
	if Models == "UseHuman_Big" then Models = {"models/gibs/humans/mgib_01.mdl","models/gibs/humans/mgib_02.mdl","models/gibs/humans/mgib_03.mdl","models/gibs/humans/mgib_04.mdl","models/gibs/humans/mgib_05.mdl","models/gibs/humans/mgib_06.mdl","models/gibs/humans/mgib_07.mdl"} end
	vTbl_Features = Tbl_Features or {}
	vTbl_Position = vTbl_Features.Pos or self:GetPos() +self:OBBCenter()
	vTbl_Angle = vTbl_Features.Ang or Angle(math.Rand(-180,180),math.Rand(-180,180),math.Rand(-180,180)) //self:GetAngles()
	vTbl_Velocity = vTbl_Features.Vel or Vector(math.Rand(-200,200),math.Rand(-200,200),math.Rand(150,250))
	vTbl_AngleVelocity = vTbl_Features.AngVel or Vector(math.Rand(-200,200),math.Rand(-200,200),math.Rand(-200,200))
	local gib = ents.Create(Ent)
	gib:SetModel(VJ_PICKRANDOMTABLE(Models))
	gib:SetPos(vTbl_Position)
	gib:SetAngles(vTbl_Angle)
	gib:Spawn()
	gib:Activate()
	if GetConVarNumber("vj_npc_gibcollidable") == 0 then gib:SetCollisionGroup(1) end
	gib:GetPhysicsObject():AddVelocity(vTbl_Velocity)
	gib:GetPhysicsObject():AddAngleVelocity(vTbl_AngleVelocity)
	cleanup.ReplaceEntity(gib)
	if GetConVarNumber("vj_npc_fadegibs") == 1 then
		if gib:GetClass() == "prop_ragdoll" then gib:Fire("FadeAndRemove","",GetConVarNumber("vj_npc_fadegibstime")) end
		if gib:GetClass() == "prop_physics" then gib:Fire("kill","",GetConVarNumber("vj_npc_fadegibstime")) end
	end
	if (CustomCode) then CustomCode(gib) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathNotice_PlayerPoints(dmginfo,hitgroup)
	local DamageInflictor = dmginfo:GetInflictor()
	local DamageAttacker = dmginfo:GetAttacker()
	if GetConVarNumber("vj_npc_showhudonkilled") == 1 then gamemode.Call("OnNPCKilled",self,DamageAttacker,DamageInflictor,dmginfo) end
	if GetConVarNumber("vj_npc_addfrags") == 1 && DamageAttacker:IsPlayer() then DamageAttacker:AddFrags(1) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilled(dmginfo,hitgroup)
	if self.VJDEBUG_SNPC_ENABLED == true then if GetConVarNumber("vj_npc_printdied") == 1 then print(self:GetClass().." Died!") end end
	self:CustomOnKilled(dmginfo,hitgroup)
	if math.random(1,self.ItemDropsOnDeathChance) == 1 then self:RunItemDropsOnDeathCode(dmginfo,hitgroup) end -- Item drops on death
	if self.HasDeathNotice == true then PrintMessage(self.DeathNoticePosition, self.DeathNoticeWriting) end -- Death notice on death
	self:ClearEnemyMemory()
	self:ClearSchedule()
	//self:SetNPCState(NPC_STATE_DEAD)
	self:CreateDeathCorpse(dmginfo,hitgroup)
	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateDeathCorpse(dmginfo,hitgroup)
	self:CustomOnDeath_BeforeCorpseSpawned(dmginfo,hitgroup)
	if self.HasDeathRagdoll == true then
		local corpsetype = "prop_physics"
		if util.IsValidRagdoll(self:GetModel()) == true then corpsetype = "prop_ragdoll" end
		if self.DeathCorpseEntityClass != "UseDefaultBehavior" then corpsetype = self.DeathCorpseEntityClass end
		//if self.VJCorpseDeleted == true then
		self.Corpse = ents.Create(corpsetype) //end
		self.Corpse:SetModel(self:GetModel())
		self.Corpse:SetPos(self:GetPos())
		self.Corpse:SetAngles(self:GetAngles())
		self.Corpse:Spawn()
		self.Corpse:Activate()
		self.Corpse:SetColor(self:GetColor())
		self.Corpse:SetMaterial(self:GetMaterial())
		//self.Corpse:SetName("self.Corpse" .. self:EntIndex())
		//self.Corpse:SetModelScale(self:GetModelScale())
		/*local dissolve = ents.Create("env_entity_dissolver") 
		dissolve:SetPos(self.Corpse:GetPos()) 
		dissolve:SetKeyValue("target", self.Corpse:GetName())
		dissolve:Spawn() 
		dissolve:Fire("Dissolve", "", 0) 
		dissolve:Fire("kill", "", 0.3)*/
		local fadetype = "kill"
		if self.Corpse:GetClass() == "prop_ragdoll" then fadetype = "FadeAndRemove" end
		self.Corpse.FadeCorpseType = fadetype
		self.Corpse.IsVJBaseCorpse = true
		self.Corpse.DamageInfo = dmginfo
		self.Corpse.ExtraCorpsesToRemove = {}
		
		if self.Bleeds == true && self.HasBloodPool == true && GetConVarNumber("vj_npc_nobloodpool") == 0 then
			local GetCorpse = self.Corpse
			local GetBloodDecal = self.BloodDecal
			local GetCustomBloodParticles = self.BloodPoolParticle
			timer.Simple(2.2,function()
				if GetCorpse:IsValid() then
					local tr = util.TraceLine({
						start = GetCorpse:GetPos() +GetCorpse:OBBCenter(),
						endpos = GetCorpse:GetPos() +GetCorpse:OBBCenter() - Vector(0,0,30),
						filter = GetCorpse, //function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
						mask = CONTENTS_SOLID
					})
					-- (X,Y,Z),(front,up,side)
					//print(tr.Fraction)
					//print(tr.HitNormal)
					if (tr.HitWorld) && tr.HitNormal == Vector(0.0,0.0,1.0) then
						//if (tr.Fraction <= 0.405) then
						if table.Count(GetCustomBloodParticles) <= 0 then // GetBloodDecal == "YellowBlood"
							local blooddecalistbl = true
							if istable(GetBloodDecal) then blooddecalistbl = true else blooddecalistbl = false end
							if (blooddecalistbl == true && table.HasValue(GetBloodDecal,"YellowBlood")) or (blooddecalistbl == false && GetBloodDecal == "YellowBlood") then
								ParticleEffect("vj_bleedout_yellow",tr.HitPos,Angle(0,0,0),nil)
							elseif (blooddecalistbl == true && table.HasValue(GetBloodDecal,"Blood")) or (blooddecalistbl == false && GetBloodDecal == "Blood") then
								ParticleEffect("vj_bleedout_red",tr.HitPos,Angle(0,0,0),nil)
							end
						else
							ParticleEffect(VJ_PICKRANDOMTABLE(GetCustomBloodParticles),tr.HitPos,Angle(0,0,0),nil) 
						end
					end
				end
			end)
		end
		
		-- Miscellaneous --
		if GetConVarNumber("ai_serverragdolls") == 0 then self.Corpse:SetCollisionGroup(1) hook.Call("VJ_CreateSNPCCorpse",nil,self.Corpse,self) else undo.ReplaceEntity(self,self.Corpse) end
		if self.CorpseAlwaysCollide == true then self.Corpse:SetCollisionGroup(0) end
		self.Corpse:SetSkin(self.DeathSkin)
		if self.DeathSkin == 0 then self.Corpse:SetSkin(self:GetSkin()) end
		if self.HasDeathBodyGroup == true then for i = 0,18 do self.Corpse:SetBodygroup(i,self:GetBodygroup(i)) end -- 18 = Bodygroup limit
		if self.CustomBodyGroup == true then self.Corpse:SetBodygroup(self.DeathBodyGroupA,self.DeathBodyGroupB) end end -- Custom Bodygroup
		cleanup.ReplaceEntity(self,self.Corpse) -- Delete on cleanup
		if GetConVarNumber("vj_npc_undocorpse") == 1 then undo.ReplaceEntity(self,self.Corpse) end -- Undoable
		if self.SetCorpseOnFire == true then self.Corpse:Ignite(math.Rand(8,10),0) end -- Set it on fire when it dies
		if self:IsOnFire() then  -- If was on fire then...
			self.Corpse:Ignite(math.Rand(8,10),0)
			self.Corpse:SetColor(Color(90,90,90))
			//self.Corpse:SetMaterial("models/props_foliage/tree_deciduous_01a_trunk")
		end
		//gamemode.Call("CreateEntityRagdoll",self,self.Corpse)
		
		-- Dissolve --
		if (dmginfo:GetDamageType() == DMG_DISSOLVE) or (IsValid(dmginfo:GetInflictor()) && dmginfo:GetInflictor():GetClass() == "prop_combine_ball") then
			self.Corpse:SetName("vj_dissolve_corpse")
			local dissolver = ents.Create("env_entity_dissolver")
			dissolver:SetPos(self.Corpse:GetPos())
			dissolver:Spawn()
			dissolver:Activate()
			dissolver:SetKeyValue("target","vj_dissolve_corpse")
			dissolver:SetKeyValue("magnitude",100)
			dissolver:SetKeyValue("dissolvetype",0)
			dissolver:Fire("Dissolve")
			dissolver:Remove()
		end
		
		-- Bone and Angle --
		local dmgforce = dmginfo:GetDamageForce()
		for bonelim = 1,128 do -- 128 = Bone Limit
			local childphys = self.Corpse:GetPhysicsObjectNum(bonelim)
			if IsValid(childphys) then
				local childphys_bonepos, childphys_boneang = self:GetBonePosition(self.Corpse:TranslatePhysBoneToBone(bonelim))
				if (childphys_bonepos) then 
					childphys:SetPos(childphys_bonepos)
					if self.UsesBoneAngle == true then childphys:SetAngles(childphys_boneang) end
					if self.Corpse:GetName() == "vj_dissolve_corpse" then
						childphys:EnableGravity(false)
						childphys:SetVelocity(self:GetForward()*-150 + self:GetRight()*math.Rand(100,-100) + self:GetUp()*50)
					else
						if self.UsesDamageForceOnDeath == true then childphys:SetVelocity(dmgforce /40) end
					end
				end
			end
		end
		
		if self.FadeCorpse == true then self.Corpse:Fire(self.Corpse.FadeCorpseType,"",self.FadeCorpseTime) end
		if GetConVarNumber("vj_npc_corpsefade") == 1 then self.Corpse:Fire(self.Corpse.FadeCorpseType,"",GetConVarNumber("vj_npc_corpsefadetime")) end
		self:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,self.Corpse)
		self.Corpse:CallOnRemove("vj_"..self.Corpse:EntIndex(),function(ent,exttbl)
			for k,v in ipairs(exttbl) do
				if IsValid(v) then
					if v:GetClass() == "prop_ragdoll" then v:Fire("FadeAndRemove","",0) else v:Fire("kill","",0) end
				end
			end
		end,self.Corpse.ExtraCorpsesToRemove)
		return self.Corpse
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateExtraDeathCorpse(Ent,Models,Tbl_Features,CustomCode)
	-- Should only be ran after self.Corpse has been created!
	if !IsValid(self.Corpse) then return end
	local dmginfo = self.Corpse.DamageInfo
	if dmginfo == nil then return end
	local dmgforce = dmginfo:GetDamageForce()
	Ent = Ent or "prop_ragdoll"
	vTbl_Features = Tbl_Features or {}
	vTbl_Position = vTbl_Features.Pos or self:GetPos()
	vTbl_Angle = vTbl_Features.Ang or self:GetAngles()
	vTbl_Velocity = vTbl_Features.Vel or dmgforce /37
	vTbl_ShouldFade = vTbl_Features.ShouldFade or false -- Should it get removed after certain time?
	vTbl_ShouldFadeTime = vTbl_Features.ShouldFadeTime or 0 -- How much time until the entity gets removed?
	vTbl_RemoveOnCorpseDelete = vTbl_Features.RemoveOnCorpseDelete or true -- Should the entity get removed if the corpse is removed?
	local extraent = ents.Create(Ent)
	extraent:SetModel(VJ_PICKRANDOMTABLE(Models))
	extraent:SetPos(vTbl_Position)
	extraent:SetAngles(vTbl_Angle)
	extraent:Spawn()
	extraent:Activate()
	extraent:SetColor(self.Corpse:GetColor())
	extraent:SetMaterial(self.Corpse:GetMaterial())
	if GetConVarNumber("ai_serverragdolls") == 0 then extraent:SetCollisionGroup(1) end
	if self.Corpse:IsOnFire() then
		extraent:Ignite(math.Rand(8,10),0)
		extraent:SetColor(Color(90,90,90))
	end
	extraent:GetPhysicsObject():AddVelocity(vTbl_Velocity)
	if vTbl_ShouldFade == true then
		if extraent:GetClass() == "prop_ragdoll" then 
			extraent:Fire("FadeAndRemove","",vTbl_ShouldFadeTime) 
		else
			extraent:Fire("kill","",vTbl_ShouldFadeTime) 
		end
	end
	if vTbl_RemoveOnCorpseDelete == true then//self.Corpse:DeleteOnRemove(extraent)
		table.insert(self.Corpse.ExtraCorpsesToRemove,extraent)
	end
	if (CustomCode) then CustomCode(extraent) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:CustomOnRemove()
	self.Dead = true
	-- Stop Things --
	self:StopAllCommonSounds()
	self:StopParticles()
	
	//if self.HasSoundTrack == true then
	//if self.HasSounds == true then
	//if GetConVarNumber("vj_npc_sd_soundtrack") == 0 then
	//if self.thememusicsd:IsPlaying() == true then
	//if self.thememusicsd then self.thememusicsd:FadeOut(self.SoundTrackFadeOutTime) end
	//end
   //end
  //end
 //end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunItemDropsOnDeathCode(dmginfo,hitgroup)
	if self.HasItemDropsOnDeath == false then return end
	self:CustomRareDropsOnDeathCode(dmginfo,hitgroup)
	local entlist = VJ_PICKRANDOMTABLE(self.ItemDropsOnDeath_EntityList)
	if entlist != false then
		local randdrop = ents.Create(entlist)
		randdrop:SetPos(self:GetPos() +self:OBBCenter())
		randdrop:SetAngles(self:GetAngles())
		randdrop:Spawn()
		randdrop:Activate()
		local phys = randdrop:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(60)
			phys:ApplyForceCenter(dmginfo:GetDamageForce())
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FollowPlayerSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasFollowPlayerSounds_Follow == false then return end
	local randomplayersound = math.random(1,self.FollowPlayerSoundChance)
	local soundtbl = self.SoundTbl_FollowPlayer
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomplayersound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
		self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
		self.CurrentFollowPlayerSound = VJ_CreateSound(self,soundtbl,self.FollowPlayerSoundLevel,self:VJ_DecideSoundPitch(self.FollowPlayerPitch1,self.FollowPlayerPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UnFollowPlayerSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasFollowPlayerSounds_UnFollow == false then return end
	local randomplayersound = math.random(1,self.UnFollowPlayerSoundChance)
	local soundtbl = self.SoundTbl_UnFollowPlayer
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomplayersound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
		self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
		self.CurrentUnFollowPlayerSound = VJ_CreateSound(self,soundtbl,self.UnFollowPlayerSoundLevel,self:VJ_DecideSoundPitch(self.UnFollowPlayerPitch1,self.UnFollowPlayerPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayerSightSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasOnPlayerSightSounds == false then return end
	local randomplayersound = math.random(1,self.OnPlayerSightSoundChance)
	local soundtbl = self.SoundTbl_OnPlayerSight
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomplayersound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentOnPlayerSightSound)
		VJ_STOPSOUND(self.CurrentAlertSound)
		self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
		self.NextAlertSoundT = CurTime() + math.random(1,2)
		self.CurrentOnPlayerSightSound = VJ_CreateSound(self,soundtbl,self.OnPlayerSightSoundLevel,self:VJ_DecideSoundPitch(self.OnPlayerSightSoundPitch1,self.OnPlayerSightSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasIdleSounds == false or self.Dead == true then return end
	if (self.NextIdleSoundT_RegularChange < CurTime()) then
		if CurTime() > self.NextIdleSoundT then
			local randomidlesound = math.random(1,self.IdleSoundChance)
			local soundtbl = self.SoundTbl_Idle
			if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
			if randomidlesound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false /*&& self:VJ_IsPlayingSoundFromTable(self.SoundTbl_Idle) == false*/ then
				self.CurrentIdleSound = VJ_CreateSound(self,soundtbl,self.IdleSoundLevel,self:VJ_DecideSoundPitch(self.IdleSoundPitch1,self.IdleSoundPitch2))
			end
			self.NextIdleSoundT = CurTime() + math.Rand(self.NextSoundTime_Idle1,self.NextSoundTime_Idle2)
		end
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AlertSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasAlertSounds == false then return end
	local randomalertsound = math.random(1,self.AlertSoundChance)
	local soundtbl = self.SoundTbl_Alert
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomalertsound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		self.NextIdleSoundT = self.NextIdleSoundT + 2
		self.CurrentAlertSound = VJ_CreateSound(self,soundtbl,self.AlertSoundLevel,self:VJ_DecideSoundPitch(self.AlertSoundPitch1,self.AlertSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DamageByPlayerSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasDamageByPlayerSounds == false then return end
	if CurTime() > self.NextDamageByPlayerSoundT then
		local randomplayersound = math.random(1,self.DamageByPlayerSoundChance)
		local soundtbl = self.SoundTbl_DamageByPlayer
		if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
		if randomplayersound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
			self.NextIdleSoundT_RegularChange = CurTime() + 1
			VJ_STOPSOUND(self.CurrentIdleSound)
			VJ_STOPSOUND(self.CurrentOnPlayerSightSound)
			timer.Simple(0.05,function() if IsValid(self) then VJ_STOPSOUND(self.CurrentPainSound) end end)
			self.CurrentDamageByPlayerSound = VJ_CreateSound(self,soundtbl,self.DamageByPlayerSoundLevel,self:VJ_DecideSoundPitch(self.DamageByPlayerPitch1,self.DamageByPlayerPitch2))
		end
		self.NextDamageByPlayerSoundT = CurTime() + math.Rand(self.NextSoundTime_DamageByPlayer1,self.NextSoundTime_DamageByPlayer2)
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BecomeEnemyToPlayerSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasBecomeEnemyToPlayerSounds == false then return end
	local randomenemyplysound = math.random(1,self.BecomeEnemyToPlayerChance)
	local soundtbl = self.SoundTbl_BecomeEnemyToPlayer
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomenemyplysound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		self.NextAlertSoundT = CurTime() + 1
		timer.Simple(1.3,function() if IsValid(self) then VJ_STOPSOUND(self.CurrentAlertSound) end end)
		self.NextIdleSoundT_RegularChange = CurTime() + math.random(2,3)
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentAlertSound)
		VJ_STOPSOUND(self.CurrentFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentOnPlayerSightSound)
		timer.Simple(0.05,function() if IsValid(self) then VJ_STOPSOUND(self.CurrentPainSound) end end)
		self.CurrentBecomeEnemyToPlayerSound = VJ_CreateSound(self,soundtbl,self.BecomeEnemyToPlayerSoundLevel,self:VJ_DecideSoundPitch(self.BecomeEnemyToPlayerPitch1,self.BecomeEnemyToPlayerPitch2))
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PainSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasPainSounds == false then return end
	if CurTime() > self.PainSoundT then
		local randompainsound = math.random(1,self.PainSoundChance)
		local soundtbl = self.SoundTbl_Pain
		if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
		if randompainsound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
			VJ_STOPSOUND(self.CurrentIdleSound)
			self.NextIdleSoundT_RegularChange = CurTime() + 1
			self.CurrentPainSound = VJ_CreateSound(self,soundtbl,self.PainSoundLevel,self:VJ_DecideSoundPitch(self.PainSoundPitch1,self.PainSoundPitch2))
		end
		self.PainSoundT = CurTime() + math.Rand(self.NextSoundTime_Pain1,self.NextSoundTime_Pain2)
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasDeathSounds == false then return end
	local deathsound = math.random(1,self.DeathSoundChance)
	local soundtbl = self.SoundTbl_Death
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if deathsound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		self.CurrentDeathSound = VJ_CreateSound(self,soundtbl,self.DeathSoundLevel,self:VJ_DecideSoundPitch(self.DeathSoundPitch1,self.DeathSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FootStepSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasFootStepSound == false or self.MovementType == VJ_MOVETYPE_STATIONARY then return end
	if self:IsOnGround() && self:GetGroundEntity() != NULL && self:IsMoving() then
		if self.DisableFootStepSoundTimer == true then
			self:CustomOnFootStepSound()
			local soundtbl = self.SoundTbl_FootStep
			if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
			if VJ_PICKRANDOMTABLE(soundtbl) != false then
				VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
			end
		end
		if self.DisableFootStepSoundTimer == false && CurTime() > self.FootStepT then
			self:CustomOnFootStepSound()
			local soundtbl = self.SoundTbl_FootStep
			if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
			if VJ_PICKRANDOMTABLE(soundtbl) != false then
				//VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
				if self.DisableFootStepOnRun == false && (table.HasValue(VJ_RunActivites,self:GetMovementActivity()) or table.HasValue(self.CustomRunActivites,self:GetMovementActivity())) then
					self:CustomOnFootStepSound_Run()
					VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
					self.FootStepT = CurTime() + self.FootStepTimeRun
				elseif self.DisableFootStepOnWalk == false && (table.HasValue(VJ_WalkActivites,self:GetMovementActivity()) or table.HasValue(self.CustomWalkActivites,self:GetMovementActivity())) then
					self:CustomOnFootStepSound_Walk()
					VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
					self.FootStepT = CurTime() + self.FootStepTimeWalk
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ImpactSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasImpactSounds == false then return end
	local randomimpactsound = math.random(1,self.ImpactSoundChance)
	local soundtbl = self.SoundTbl_Impact
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomimpactsound == 1 then
		if VJ_PICKRANDOMTABLE(soundtbl) == false then
			VJ_EmitSound(self,self.DefaultSoundTbl_Impact,self.ImpactSoundLevel,self:VJ_DecideSoundPitch(self.ImpactSoundPitch1,self.ImpactSoundPitch2))
		else
			VJ_EmitSound(self,soundtbl,self.ImpactSoundLevel,self:VJ_DecideSoundPitch(self.ImpactSoundPitch1,self.ImpactSoundPitch2))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:ThemeMusicCode()
/*if GetConVarNumber("vj_npc_sd_nosounds") == 0 then
if GetConVarNumber("vj_npc_sd_soundtrack") == 0 then
	self.thememusicsd = CreateSound( player.GetByID( 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,71,72,73,74,75,76,77,78,79,80,81,82,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100 ), self.Theme )
	self.thememusicsd:Play();
	self.thememusicsd:Stop();
	self.thememusicsd:SetSoundLevel( self.SoundTrackLevel )
	if self.thememusicsd:IsPlaying() == false then self.thememusicsd:Play();
   end
  end
 end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartSoundTrack()
	if self.HasSounds == false then return end
	if self.HasSoundTrack == false then return end
	self.VJ_IsPlayingSoundTrack = true
	net.Start("vj_music_run")
	net.WriteEntity(self)
	net.WriteTable(self.SoundTbl_SoundTrack)
	net.WriteFloat(self.SoundTrackVolume)
	net.WriteFloat(self.SoundTrackPlaybackRate)
	net.WriteFloat(self.SoundTrackFadeOutTime)
	net.Broadcast()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAllCommonSounds()
	VJ_STOPSOUND(self.CurrentBreathSound)
	VJ_STOPSOUND(self.CurrentIdleSound)
	VJ_STOPSOUND(self.CurrentAlertSound)
	VJ_STOPSOUND(self.CurrentPainSound)
	VJ_STOPSOUND(self.CurrentFollowPlayerSound)
	VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
	VJ_STOPSOUND(self.CurrentBecomeEnemyToPlayerSound)
	VJ_STOPSOUND(self.CurrentOnPlayerSightSound)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:NoCollide_CombineBall()
	for k, v in pairs (ents.GetAll()) do
		if v:GetClass() == "prop_combine_ball" then
			constraint.NoCollide( self, v, 0, 0 )
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WorldShakeOnMoveCode()
	if self.HasWorldShakeOnMove == false or self.MovementType == VJ_MOVETYPE_STATIONARY then return end
	if self:IsOnGround() && self:IsMoving() && CurTime() > self.WorldShakeWalkT then
		self:CustomOnWorldShakeOnMove()
		if self.DisableWorldShakeOnMoveWhileRunning == false && (table.HasValue(VJ_RunActivites,self:GetMovementActivity()) or table.HasValue(self.CustomRunActivites,self:GetMovementActivity())) then
			self:CustomOnWorldShakeOnMove_Run()
			util.ScreenShake(self:GetPos(),self.WorldShakeOnMoveAmplitude,self.WorldShakeOnMoveFrequency,self.WorldShakeOnMoveDuration,self.WorldShakeOnMoveRadius)
			self.WorldShakeWalkT = CurTime() + self.NextWorldShakeOnRun
		elseif self.DisableWorldShakeOnMoveWhileWalking == false && (table.HasValue(VJ_WalkActivites,self:GetMovementActivity()) or table.HasValue(self.CustomWalkActivites,self:GetMovementActivity())) then
			self:CustomOnWorldShakeOnMove_Walk()
			util.ScreenShake(self:GetPos(),self.WorldShakeOnMoveAmplitude,self.WorldShakeOnMoveFrequency,self.WorldShakeOnMoveDuration,self.WorldShakeOnMoveRadius)
			self.WorldShakeWalkT = CurTime() + self.NextWorldShakeOnWalk
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EntitiesToNoCollideCode()
	if !istable(self.EntitiesToNoCollide) then return end
	if #self.EntitiesToNoCollide < 1 then return end
	for k, v in pairs (ents.GetAll()) do
		if table.HasValue(self.EntitiesToNoCollide,v:GetClass()) then
		constraint.NoCollide(self,v,0,0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ConvarsOnInit()
--<>-- Convars that run on Initialize --<>--
	if GetConVarNumber("vj_npc_usedevcommands") == 1 then self.VJDEBUG_SNPC_ENABLED = true end
	if GetConVarNumber("vj_npc_sd_nosounds") == 1 then self.HasSounds = false end
	if GetConVarNumber("vj_npc_playerfriendly") == 1 then self.PlayerFriendly = true end
	if GetConVarNumber("vj_npc_zombiefriendly") == 1 then self.ZombieFriendly = true end
	if GetConVarNumber("vj_npc_antlionfriendly") == 1 then self.AntlionFriendly = true end
	if GetConVarNumber("vj_npc_combinefriendly") == 1 then self.CombineFriendly = true end
	if GetConVarNumber("vj_npc_noallies") == 1 then
		self.HasAllies = false
		self.ZombieFriendly = false
		self.AntlionFriendly = false
		self.CombineFriendly = false
		self.PlayerFriendly = false
	end
	if GetConVarNumber("vj_npc_nocorpses") == 1 then self.HasDeathRagdoll = false end
	if GetConVarNumber("vj_npc_itemdrops") == 0 then self.HasItemDropsOnDeath = false end
	if GetConVarNumber("vj_npc_animal_runontouch") == 1 then self.RunOnTouch = false end
	if GetConVarNumber("vj_npc_animal_runonhit") == 1 then self.RunAwayOnUnknownDamage = false end
	if GetConVarNumber("vj_npc_nowandering") == 1 then self.DisableWandering = true end
	if GetConVarNumber("vj_npc_nochasingenemy") == 1 then self.DisableChasingEnemy = true end
	if GetConVarNumber("vj_npc_noflinching") == 1 then self.CanFlinch = false end
	if GetConVarNumber("vj_npc_nobleed") == 1 then self.Bleeds = false end
	if GetConVarNumber("vj_npc_godmodesnpc") == 1 then self.GodMode = true end
	if GetConVarNumber("vj_npc_nobecomeenemytoply") == 1 then self.BecomeEnemyToPlayer = false end
	if GetConVarNumber("vj_npc_nofollowplayer") == 1 then self.FollowPlayer = false end
	if GetConVarNumber("vj_npc_nosnpcchat") == 1 then self.FollowPlayerChat = false end
	if GetConVarNumber("vj_npc_nogibdeathparticles") == 1 then self.HasGibDeathParticles = false end
	if GetConVarNumber("vj_npc_nogib") == 1 then self.AllowedToGib = false self.HasGibOnDeath = false end
	if GetConVarNumber("vj_npc_sd_gibbing") == 1 then self.HasGibOnDeathSounds = false end
	if GetConVarNumber("vj_npc_sd_soundtrack") == 1 then self.HasSoundTrack = false end
	if GetConVarNumber("vj_npc_sd_footstep") == 1 then self.HasFootStepSound = false end
	if GetConVarNumber("vj_npc_sd_idle") == 1 then self.HasIdleSounds = false end
	if GetConVarNumber("vj_npc_sd_breath") == 1 then self.HasBreathSound = false end
	if GetConVarNumber("vj_npc_sd_alert") == 1 then self.HasAlertSounds = false end
	if GetConVarNumber("vj_npc_sd_pain") == 1 then self.HasPainSounds = false end
	if GetConVarNumber("vj_npc_sd_death") == 1 then self.HasDeathSounds = false end
	if GetConVarNumber("vj_npc_sd_followplayer") == 1 then self.HasFollowPlayerSounds_Follow = false self.HasFollowPlayerSounds_UnFollow = false end
	if GetConVarNumber("vj_npc_sd_becomenemytoply") == 1 then self.HasBecomeEnemyToPlayerSounds = false end
	if GetConVarNumber("vj_npc_sd_onplayersight") == 1 then self.HasOnPlayerSightSounds = false end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ConvarsOnThink() -- Obsolete! | Causes lag!
end
/*--------------------------------------------------
	=============== Animal SNPC Base ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make animal SNPCs
--------------------------------------------------*/