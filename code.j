function Seconds2String takes integer T returns string

	local integer H = 0
	local integer M = 0
	local integer S = T
	
	loop
		exitwhen S < 60
		set M = M+1
		set S = S-60
	endloop
	
	loop
		exitwhen M < 60
		set H = H+1
		set M = M-60
	endloop
	
	return I2S(H)+":"+I2S(M)+":"+I2S(S)

endfunction

function B2I takes boolean B returns integer

	if B then
		return 1
	else
		return 0
	endif

endfunction

function I2B takes integer I returns boolean

	if I > 0 then
		return true
	else
		return false
	endif

endfunction

function Char2Id takes string c returns integer
    local integer i = 0
    local string abc = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    local string t

    loop
        set t = SubString(abc,i,i + 1)
        exitwhen t == null or t == c
        set i = i + 1
    endloop
    if i < 10 then
        return i + 48
    elseif i < 36 then
        return i + 65 - 10
    endif
    return i + 97 - 36
endfunction

function String2Id takes string s returns integer
	if s == "0000" or s== "0" then
		return 0
	else
		return ((Char2Id(SubString(s,0,1)) * 256 + Char2Id(SubString(s,1,2))) * 256 + Char2Id(SubString(s,2,3))) * 256 + Char2Id(SubString(s,3,4))
	endif
endfunction

function Id2Char takes integer i returns string
    local string abc = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

	if i < 48 then
		call BJDebugMsg("Invalid char error")
	endif

    if i >= 97 then
        return SubString(abc,i - 97 + 36,i - 96 + 36)
    elseif i >= 65 then
        return SubString(abc,i - 65 + 10,i - 64 + 10)
    endif
    return SubString(abc,i - 48,i - 47)
endfunction

function Id2String takes integer id1 returns string
	local integer t
	local string r
	local integer id2
	
	if id1 == 0 then
		return "0000"
	else
		set t = id1 / 256
		set r = Id2Char(id1 - 256 * t)
		set id2 = t / 256
		set r = Id2Char(t - 256 * id2) + r
		set t = id2 / 256
		return Id2Char(t) + Id2Char(id2 - 256 * t) + r
	endif
endfunction

function findChar takes string toFind, string String returns integer

	local integer i = 0
	local string currentChar = SubString(String, 0, 1)
	local integer ans

	loop
		exitwhen toFind == currentChar or i == StringLength(String)

		set i = i + 1
		set currentChar = SubString(String, i, i+1)		

	endloop

	if i == StringLength(String) and currentChar != toFind then
		set ans = -1
	else
		set ans = i
	endif

	return ans

endfunction

function reverseString takes string toReverse returns string

    local integer len = StringLength(toReverse)
    local integer i = 0
    local string ans = ""
    
    loop
        exitwhen i >= len
        
        set ans = ans + SubString(toReverse,len-i-1, len-i)
        
        set i = i+1
    
    endloop
    
    return ans

endfunction

function Po2 takes integer x returns integer

	local integer ans = 1
	local integer i = 0
	loop
		exitwhen i >= x
		
		set ans = ans*2
		set i = i+1
		
	endloop
	
	return ans

endfunction


function I2BinaryString takes integer x, integer s returns string

	local integer temp = x
	local string ans = ""
	local integer d
	
	local integer i = 0
	
	loop
		exitwhen i >= s
		
		if temp > 0 then
		
			set d = temp - (temp/2)*2
			
			set ans = ans + I2S(d)
			
			set temp = ((temp - d)/2)
			
		else
		
			set ans = ans + "0"
		
		endif
		
		set i = i+1
	
	endloop
	
	if temp == 0 then
	else
	
		call BJDebugMsg("The binary string conversion has encountered a critical error, and the save data has been corrupted.")
		call BJDebugMsg("Number: "+I2S(x))
		call BJDebugMsg("Rawcode: "+Id2String(x))
		call BJDebugMsg("Size: "+I2S(s))
	
	endif

	set ans = reverseString(ans)
	
	return ans

endfunction

function BinaryString2I takes string n returns integer

	local integer i = 0
	local string nbackwards = reverseString(n)
	local string currentChar = SubString(nbackwards, 0, 1)
	local integer ans = 0

	loop
		exitwhen i >= StringLength(n)
		
		set ans = ans + S2I(currentChar)*Po2(i)

		set i = i + 1
		set currentChar = SubString(nbackwards, i, i+1)		

	endloop

	return ans

endfunction

function AdjustHeroHealth takes unit H, integer targetHealth returns nothing

	local integer tempHealth = R2I(GetUnitStateSwap(UNIT_STATE_MAX_LIFE, H))

	loop
		exitwhen tempHealth >= targetHealth
		
		call UnitAddItemByIdSwapped( 'manh', H )
		
		set tempHealth = R2I(GetUnitStateSwap(UNIT_STATE_MAX_LIFE, H))
	
	endloop

endfunction

function SetHeroSkill takes unit H, integer skill, integer level returns nothing

	local integer i = 0
	
	loop
		exitwhen i >= level
		
		call SelectHeroSkill(H, skill)

		set i = i+1
	endloop

endfunction

function SetHeroSkills takes unit H, integer skillOne, integer skillTwo, integer skillThree, integer skillFour, integer skillFive returns nothing

	local integer array skillTypes
	local integer i = 0

	set skillTypes[0] = skillOne
	set skillTypes[1] = skillTwo
	set skillTypes[2] = skillThree
	set skillTypes[3] = skillFour
	set skillTypes[4] = skillFive
	
	loop
		exitwhen i >= 5
		
		if skillTypes[i] != 0 then
			call SetHeroSkill(H, skillTypes[i], udg_SaveLoadHeroAbilities[i])
		endif
		
		set i = i+1
	endloop

endfunction

function CoopDisplayCode takes string toDisplay returns string

    
	local integer i = 0
	local string currentChar = SubString(toDisplay, 0, 1)
	local string ans = ""

	loop
		exitwhen i == StringLength(toDisplay)

		if currentChar == "I" then
			set ans = ans + "|cffffcc00I|r"
		else
			set ans = ans + currentChar
		endif

		set i = i + 1
		set currentChar = SubString(toDisplay, i, i+1)		

	endloop

	return ans

endfunction

function CoopEncode takes integer toEncode returns string

	local integer temp = toEncode
	local string key = "0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM&*"
	local integer keylen = 64
	local integer currentDigit
	local string ans = ""

	loop
		exitwhen temp < keylen

		
		set currentDigit = temp - (keylen * (temp / keylen))
		set temp = (temp / keylen)
		set ans = ans + SubString(key, currentDigit, currentDigit+1)
  
  
	endloop

	set ans = ans + SubString(key, temp, temp+1)

	set ans = reverseString(ans)	

	return ans

endfunction


function CoopDecode takes string toDecode returns integer

	
	local string key = "0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM&*"
	local integer keylen = 64
	local integer ans = 0

	local integer i = 0

	local boolean error = false

	loop
		exitwhen i == StringLength(toDecode)

		if findChar(SubString(toDecode,i,i+1),key) == -1 then
			set error = true
		endif

		set ans = ans + Po2((StringLength(toDecode)-i-1)*6)*findChar(SubString(toDecode,i,i+1),key)
		set i = i+1
  
  
	endloop

	if error then
		set ans = -1
	endif

	return ans

endfunction

function CoopEncodeHeroBinary takes unit H, integer skillOne, integer skillTwo, integer skillThree, integer skillFour, integer skillFive returns string

	local integer array skillTypes

	local integer xp
	local integer hp
	local integer str
	local integer agi
	local integer int
	local integer array skills
	local integer skillpoints
	local integer array items
	local integer array itemcharges
	
	local string bin
	
	local integer i = 0
	
	set skillTypes[0] = skillOne
	set skillTypes[1] = skillTwo
	set skillTypes[2] = skillThree
	set skillTypes[3] = skillFour
	set skillTypes[4] = skillFive

	set xp = GetHeroXP( H )
	set bin = I2BinaryString(xp, 16)
	
	set hp = R2I(GetUnitStateSwap(UNIT_STATE_MAX_LIFE, H))
	set bin = bin + I2BinaryString(hp, 16)
	
	set str = GetHeroStatBJ(bj_HEROSTAT_STR, H, false)
	set bin = bin + I2BinaryString(str, 9)
	
	set agi = GetHeroStatBJ(bj_HEROSTAT_AGI, H, false)
	set bin = bin + I2BinaryString(agi, 9)
	
	set int = GetHeroStatBJ(bj_HEROSTAT_INT, H, false)
	set bin = bin + I2BinaryString(int, 9)
	
	loop
		exitwhen i >= 5
		if skillTypes[i] == 0 then
			set skills[i] = 0
		else
			set skills[i] = GetUnitAbilityLevel(H, skillTypes[i])
		endif
		set bin = bin + I2BinaryString(skills[i], 3)
		
		set i = i+1
	endloop
	
	set skillpoints = GetHeroSkillPoints(H)
	set bin = bin + I2BinaryString(skillpoints, 6)
	
	set i = 0
	loop
		exitwhen i >= 6
		
		set items[i] = GetItemTypeId(UnitItemInSlotBJ(H, i+1))
		//call BJDebugMsg("Item "+I2S(i)+" type id: "+I2S(items[i])+" ("+Id2String(items[i])+")")
		set bin = bin + I2BinaryString(CoopDecode(Id2String(items[i])), 24)
		set itemcharges[i] = GetItemCharges(UnitItemInSlotBJ(H, i+1))
		set bin = bin + I2BinaryString(itemcharges[i], 4)
		
		set i = i+1
	endloop

	return bin

endfunction

function CoopEncodeHero64 takes string binarycode returns string

	local string bin
	local integer i
	
	local string ans = ""

	set bin = "0000"+binarycode
	
	set i = 0
	loop
		exitwhen i >= 42
		
		set ans = ans + CoopEncode(BinaryString2I(SubString(bin, i*6, (i+1)*6)))
		
		set i = i+1
	endloop
	
	//call BJDebugMsg("Hero encoded, code: "+ans)
	//call BJDebugMsg("Size: "+I2S(StringLength(ans))+" digits, "+I2S(StringLength(ans)*6)+" bits")
	
	return ans

endfunction

function CoopEncodeHero takes unit H, integer skillOne, integer skillTwo, integer skillThree, integer skillFour, integer skillFive returns string

	return CoopEncodeHero64(CoopEncodeHeroBinary(H, skillOne, skillTwo, skillThree, skillFour, skillFive))

endfunction

function CoopLocalSaveHero takes unit H, integer skillOne, integer skillTwo, integer skillThree, integer skillFour, integer skillFive, player P, string Path returns nothing

	local string herocode
	local string injector
	
	if GetLocalPlayer() == P then
	
		set herocode = CoopEncodeHero(H, skillOne, skillTwo, skillThree, skillFour, skillFive)
		
		//set injector = " \" ) \n call StoreInteger(InitGameCache(\"CoopGameCache\"), \"cooplocal\", \"coopcode\", "+I2S(commcode)+") \n "+"call Preload( \" "
		
		call PreloadGenClear()
		call PreloadGenStart()
		call Preload( "\" )
		call SetPlayerName( Player( 15 ) , \"" + herocode + "\" )  //")
		call Preload( "\" )
		endfunction
		function Speedup takes nothing returns nothing //")
		call PreloadGenEnd("save\\CoopCampaign\\Bank\\"+Path+".dat")
		
	endif
	
endfunction

function CoopLocalLoadHero takes player P, string Path returns nothing

	local string herocode
	local string bin
	local integer i
	
	local integer currentPackage

	//call BJDebugMsg("Loading hero from file...")
	
	call TriggerSyncStart()

	if GetLocalPlayer() == P then
	
		call SetPlayerName(Player(15), "0")
		call Preloader("save\\CoopCampaign\\Bank\\"+Path+".dat")
		set herocode = GetPlayerName(Player(15))
		
		//call BJDebugMsg("Hero code is: "+herocode)
		
		set bin = ""
		set i = 0
		loop
			exitwhen i >= StringLength(herocode)
			
			set bin = bin + I2BinaryString(CoopDecode(SubString(herocode, i, i+1)), 6)
			
			set i = i+1
		endloop
		
		set bin = SubString(bin, 4, 252)
		
		//call BJDebugMsg("Binary code is: "+bin)
		//call BJDebugMsg("Size: "+I2S(StringLength(bin)))
		//call BJDebugMsg("Reconstructed Hero Code: "+CoopEncodeHero64(bin))
		
		set i = 0
		loop
			exitwhen i >=  8
			
			set currentPackage = BinaryString2I(SubString(bin, i*31, (i+1)*31))
			
			//call BJDebugMsg("Sending package "+I2S(i)+": "+I2S(currentPackage)+", binary: "+I2BinaryString(currentPackage, 31))
			
			call StoreInteger(udg_CoopGameCache, "coopplayer"+I2S(GetConvertedPlayerId(P)), "coopcode"+I2S(i), currentPackage)
			call SyncStoredInteger(udg_CoopGameCache, "coopplayer"+I2S(GetConvertedPlayerId(P)), "coopcode"+I2S(i))
			
			set i = i+1
		endloop
		
	endif
	
	call TriggerSyncReady()
	
	set udg_CoopSyncDone = true

endfunction

function CoopLocalSaveCurrentHero takes player P, string Path returns nothing
	call CoopLocalSaveHero(udg_SaveLoadHero, udg_SaveLoadHeroSkillIDs[0], udg_SaveLoadHeroSkillIDs[1], udg_SaveLoadHeroSkillIDs[2], udg_SaveLoadHeroSkillIDs[3], udg_SaveLoadHeroSkillIDs[4], P, Path)
endfunction

function CoopDecodeHero takes player P, gamecache cache returns nothing

	local integer package

	local integer xp
	local integer hp
	local integer str
	local integer agi
	local integer int
	local integer array skills
	local integer skillpoints
	local integer array items
	local integer array itemcharges
	
	local string bin = ""
	
	local integer i = 0
	
	//call BJDebugMsg("Decoding hero...")
	
	set i = 0
	loop
		exitwhen i >= 8
		
		set package = GetStoredInteger(cache, "coopplayer"+I2S(GetConvertedPlayerId(P)), "coopcode"+I2S(i))
		set bin = bin + I2BinaryString(package, 31)


		set i = i+1
	endloop
	
	//call BJDebugMsg("Binary string: "+bin+", size "+I2S(StringLength(bin)))
	//call BJDebugMsg("Save code restored from binary string: "+CoopEncodeHero64(bin))

	set xp = BinaryString2I(SubString(bin, 0, 16))
	
	set hp = BinaryString2I(SubString(bin, 16, 32))
	
	set str = BinaryString2I(SubString(bin, 32, 41))
	
	set agi = BinaryString2I(SubString(bin, 41, 50))
	
	set int = BinaryString2I(SubString(bin, 50, 59))
	
	set i = 0
	loop
		exitwhen i >= 5
		
		set skills [i] = BinaryString2I(SubString(bin, 59+(i*3), 62+(i*3)))
		
		set i = i+1
	endloop
	
	set skillpoints = BinaryString2I(SubString(bin, 74, 80))
	
	set i = 0
	loop
		exitwhen i >= 6
		
		set items[i] = BinaryString2I(SubString(bin, 80+(i*28), 80+(i*28)+24))
		set itemcharges[i] = BinaryString2I(SubString(bin, 80+(i*28)+24, 80+(i*28)+24+4))
		
		set i = i+1
	endloop
	
	set udg_SaveLoadHeroXP = xp
	set udg_SaveLoadHeroHP = hp
	set udg_SaveLoadHeroStrength = str
	set udg_SaveLoadHeroAgility = agi
	set udg_SaveLoadHeroIntelligence = int
	set i = 0
	loop
		exitwhen i >= 5
		
		set udg_SaveLoadHeroAbilities[i] = skills[i]
		
		set i = i+1
	endloop
	set udg_SaveLoadHeroSkillPoints = skillpoints
	set i = 0
	loop
		exitwhen i >= 6
		
		set udg_SaveLoadHeroItemIDs[i] = String2Id(CoopEncode(items[i]))
		set udg_SaveLoadHeroItemCharges[i] = itemcharges[i]
		
		set i = i+1
	endloop
	
	//call BJDebugMsg("XP: "+I2S(xp))
	//call BJDebugMsg("STR: "+I2S(str))
	//call BJDebugMsg("AGI: "+I2S(agi))
	//call BJDebugMsg("INT: "+I2S(int))
	//call BJDebugMsg("Ability Points: "+I2S(skills[0])+", "+I2S(skills[1])+", "+I2S(skills[2])+", "+I2S(skills[3])+", unspent: "+I2S(skillpoints))	
	set i = 0
	loop
		exitwhen i >= 6
		
		//call BJDebugMsg("Item "+I2S(i+1)+": "+Id2String(String2Id(CoopEncode(items[i])))+", "+I2S(itemcharges[i])+" charges")	
		
		set i = i+1
	endloop


endfunction

function CoopEncodeMetadata takes integer insaneMode, integer maxMission, integer gameTime, integer gameScore returns string

	local string bin = ""
	
	local integer i
	
	local string ans = ""
	
	set bin = bin + I2BinaryString(insaneMode, 1)
	set bin = bin + I2BinaryString(maxMission, 4)
	set bin = bin + I2BinaryString(gameTime, 18)
	set bin = bin + I2BinaryString(gameScore, 8)
	
	set bin = "00000"+bin
	
	set i = 0
	loop
		exitwhen i >= 6 
		
		set ans = ans + CoopEncode(BinaryString2I(SubString(bin, i*6, (i+1)*6)))
		
		set i = i+1
	endloop
	
	//call BJDebugMsg("Date encoded, code: "+ans)
	//call BJDebugMsg("Size: "+I2S(StringLength(ans))+" digits, "+I2S(StringLength(ans)*6)+" bits")
	
	return ans

endfunction

function CoopLocalSaveMetadata takes player P, string Path, integer insaneMode, integer maxMission, integer gameTime, integer gameScore returns nothing

	local string datacode
	local string injector
	
	if GetLocalPlayer() == P then
	
		set datacode = CoopEncodeMetadata(insaneMode, maxMission, gameTime, gameScore)
		
		//set injector = " \" ) \n call StoreInteger(InitGameCache(\"CoopGameCache\"), \"cooplocal\", \"coopcode\", "+I2S(commcode)+") \n "+"call Preload( \" "
		
		call PreloadGenClear()
		call PreloadGenStart()
		call Preload( "\" )
		call SetPlayerName( Player( 15 ) , \"" + datacode + "\" )  //")
		call Preload( "\" )
		endfunction
		function Speedup takes nothing returns nothing //")
		call PreloadGenEnd("save\\CoopCampaign\\Bank\\"+Path+".dat")
		
	endif

endfunction

function CoopLoadMetadata takes player P, string Path returns nothing

	local string datacode
	local string bin
	local integer i
	
	local integer currentPackage

	//call BJDebugMsg("Loading metadata from file...")
	
	call TriggerSyncStart()

	if GetLocalPlayer() == P then
	
		call SetPlayerName(Player(15), "0")
		call Preloader("save\\CoopCampaign\\Bank\\"+Path+".dat")
		set datacode = GetPlayerName(Player(15))
		
		//call BJDebugMsg("Metadata code is: "+datacode)
		
		set bin = ""
		set i = 0
		loop
			exitwhen i >= StringLength(datacode)
			
			set bin = bin + I2BinaryString(CoopDecode(SubString(datacode, i, i+1)), 6)
			
			set i = i+1
		endloop
		
		set bin = SubString(bin, 5, 36)
		
		//call BJDebugMsg("Binary code is: "+bin)
		//call BJDebugMsg("Size: "+I2S(StringLength(bin)))
		
		set i = 0
		loop
			exitwhen i >= 1
			
			set currentPackage = BinaryString2I(SubString(bin, i*31, (i+1)*31))
			
			//call BJDebugMsg("Sending package "+I2S(i)+": "+I2S(currentPackage)+", binary: "+I2BinaryString(currentPackage, 31))
			
			call StoreInteger(udg_CoopGameCache, "coopplayer"+I2S(GetConvertedPlayerId(P)), "coopcode"+I2S(i), currentPackage)
			call SyncStoredInteger(udg_CoopGameCache, "coopplayer"+I2S(GetConvertedPlayerId(P)), "coopcode"+I2S(i))
			
			set i = i+1
		endloop
		
	endif
	
	call TriggerSyncReady()
	
	set udg_CoopSyncDone = true

endfunction

function CoopDecodeMetadata takes player P, gamecache cache returns nothing

	local integer package

	local integer insaneMode
	local integer maxMission
	local integer gameTime
	local integer gameScore
	
	local string bin = ""
	
	local integer i = 0
	
	//call BJDebugMsg("Decoding metadata...")
	
	set i = 0
	loop
		exitwhen i >= 1
		
		set package = GetStoredInteger(cache, "coopplayer"+I2S(GetConvertedPlayerId(P)), "coopcode"+I2S(i))
		set bin = bin + I2BinaryString(package, 31)


		set i = i+1
	endloop
	
	set insaneMode = BinaryString2I(SubString(bin, 0, 1))
	set maxMission = BinaryString2I(SubString(bin, 1, 5))
	set gameTime = BinaryString2I(SubString(bin, 5, 23))
	set gameScore = BinaryString2I(SubString(bin, 23, 31))
	
	set udg_CoopMetaInsane = insaneMode
	set udg_CoopMetaMaxMission = maxMission
	set udg_CoopMetaGameTime = gameTime
	set udg_CoopMetaGameScore = gameScore

endfunction