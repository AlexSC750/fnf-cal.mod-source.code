package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

class ClientPrefs {
	public static var downScroll:Bool = false;
	public static var middleScroll:Bool = false;
	public static var showFPS:Bool = true;
	public static var flashing:Bool = true;
	public static var autosaveInterval:Int = 5;
	public static var autosavecharts:Bool = true;
	public static var themedmainmenubg:Bool = false;
	public static var autotitleskip:Bool = false;
	public static var globalAntialiasing:Bool = true;
	public static var noteSplashes:Bool = true;
	public static var lowQuality:Bool = false;
	public static var framerate:Int = 60;
	public static var cursing:Bool = true;
	public static var violence:Bool = true;
	public static var camZooms:Bool = true;
	public static var hideHud:Bool = false;
	public static var hideWatermark:Bool = false;
	public static var hideScoreText:Bool = false;
	public static var noteOffset:Int = 0;
	public static var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
	public static var imagesPersist:Bool = false;
	public static var ghostTapping:Bool = true;
	public static var timeBarType:String = 'Time Left';
	public static var iconbops:String = 'OS';
	public static var colorblindMode:String = 'None';
	public static var opponentStrums:Bool = false;
	public static var scoreZoom:Bool = true;
	public static var noReset:Bool = false;
	public static var showMsText:Bool = true;
	public static var healthBarAlpha:Float = 1;
	public static var controllerMode:Bool = false;
	public static var hitsoundVolume:Float = 0;
	public static var underlaneVisibility:Float = 0;
	public static var holdNoteVisibility:Float = 1;
	public static var opponentUnderlaneVisibility:Float = 0;
	public static var noteSkinSettings:String = 'Classic';
	public static var pauseMusic:String = 'Tea Time';
	public static var showcaseMode:Bool = false;
	public static var cameramoveonnotes:Bool = true;
	public static var characterTrail:Bool = false;
	public static var checkForUpdates:Bool = true;
	public static var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative', 
		// anyone reading this, amod is multiplicative speed mod, cmod is constant speed mod, and xmod is bpm based speed mod.
		// an amod example would be chartSpeed * multiplier
		// cmod would just be constantSpeed = chartSpeed
		// and xmod basically works by basing the speed on the bpm.
		// iirc (beatsPerSecond * (conductorToNoteDifference / 1000)) * noteSize (110 or something like that depending on it, prolly just use note.height)
		// bps is calculated by bpm / 60
		// oh yeah and you'd have to actually convert the difference to seconds which I already do, because this is based on beats and stuff. but it should work
		// just fine. but I wont implement it because I don't know how you handle sustains and other stuff like that.
		// oh yeah when you calculate the bps divide it by the songSpeed or rate because it wont scroll correctly when speeds exist.
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'mirrorcharts' => false,
		'randomcharts' => false
	];

	public static var comboOffset:Array<Int> = [0, 0, 0, 0];
	public static var ratingOffset:Int = 0;

	public static final hitWindowMap:Map<String, Array<Int>> = [ //no idea wth final is but i think it can't be written to so thats good
		'Peaceful' => [23,57,101,141,169],
		'Lenient' => [20,52,91,128,153],
		'Chill' => [19,47,83,116,139],
		'Standard*' => [18,43,76,106,127],
		'Tough' => [14,35,62,87,111],
		'Extreme' => [13,32,57,79,100],
		'Impossible' => [8,20,35,49,75],
		'JUSTICE' => [4,9,18,27,36] //joke
	];

	public static var hitWindowPreset:String = 'Standard*';
		public static var marvWindow:Int = 18;
		public static var perfWindow:Int = 43;
		public static var greatWindow:Int = 76;
		public static var goodWindow:Int = 106;
		public static var okWindow:Int = 127;
	public static var safeFrames:Float = 10;
	//Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		//Key Bind, Name for ControlsSubState
		'note_left'		=> [A, LEFT],
		'note_down'		=> [S, DOWN],
		'note_up'		=> [W, UP],
		'note_right'	=> [D, RIGHT],
		
		'ui_left'		=> [A, LEFT],
		'ui_down'		=> [S, DOWN],
		'ui_up'			=> [W, UP],
		'ui_right'		=> [D, RIGHT],
		
		'accept'		=> [SPACE, ENTER],
		'back'			=> [BACKSPACE, ESCAPE],
		'pause'			=> [ENTER, ESCAPE],
		'reset'			=> [R, NONE],
		
		'volume_mute'	=> [ZERO, NONE],
		'volume_up'		=> [NUMPADPLUS, PLUS],
		'volume_down'	=> [NUMPADMINUS, MINUS],
		
		'debug_1'		=> [SEVEN, NONE],
		'debug_2'		=> [EIGHT, NONE]
	];
	public static var defaultKeys:Map<String, Array<FlxKey>> = null;

	public static function loadDefaultKeys() {
		defaultKeys = keyBinds.copy();
		//trace(defaultKeys);
	}

	public static function saveSettings() {
		FlxG.save.data.downScroll = downScroll;
		FlxG.save.data.middleScroll = middleScroll;
		FlxG.save.data.showFPS = showFPS;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.globalAntialiasing = globalAntialiasing;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.framerate = framerate;
		//FlxG.save.data.cursing = cursing;
		//FlxG.save.data.violence = violence;
		FlxG.save.data.camZooms = camZooms;
		FlxG.save.data.colorblindMode = colorblindMode;
		FlxG.save.data.opponentStrums = opponentStrums;
		FlxG.save.data.noteOffset = noteOffset;
		FlxG.save.data.hideHud = hideHud;
		FlxG.save.data.hideWatermark = hideWatermark;
		FlxG.save.data.hideScoreText = hideScoreText;
		FlxG.save.data.arrowHSV = arrowHSV;
		FlxG.save.data.imagesPersist = imagesPersist;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.timeBarType = timeBarType;
		FlxG.save.data.scoreZoom = scoreZoom;
		FlxG.save.data.characterTrail = characterTrail;
		FlxG.save.data.noReset = noReset;
		FlxG.save.data.showMsText = showMsText;
		FlxG.save.data.holdNoteVisibility = holdNoteVisibility;
		FlxG.save.data.healthBarAlpha = healthBarAlpha;
		FlxG.save.data.comboOffset = comboOffset;
		FlxG.save.data.achievementsMap = Achievements.achievementsMap;
		FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;
		FlxG.save.data.autosaveInterval = autosaveInterval;
		FlxG.save.data.autosavecharts = autosavecharts;
		FlxG.save.data.themedmainmenubg = themedmainmenubg;
		FlxG.save.data.autotitleskip = autotitleskip;
		FlxG.save.data.iconbops = iconbops;

		FlxG.save.data.ratingOffset = ratingOffset;
		FlxG.save.data.showcaseMode = showcaseMode;

		FlxG.save.data.hitWindowPreset = hitWindowPreset;
			FlxG.save.data.marvWindow = hitWindowMap[hitWindowPreset][0];
			FlxG.save.data.perfWindow = hitWindowMap[hitWindowPreset][1];
			FlxG.save.data.greatWindow = hitWindowMap[hitWindowPreset][2];
			FlxG.save.data.goodWindow = hitWindowMap[hitWindowPreset][3];
			FlxG.save.data.okWindow = hitWindowMap[hitWindowPreset][4];
		FlxG.save.data.safeFrames = safeFrames;
		FlxG.save.data.gameplaySettings = gameplaySettings;
		FlxG.save.data.controllerMode = controllerMode;
		FlxG.save.data.hitsoundVolume = hitsoundVolume;
		FlxG.save.data.underlaneVisibility = underlaneVisibility;
		FlxG.save.data.pauseMusic = pauseMusic;
		FlxG.save.data.noteSkinSettings = noteSkinSettings;
		FlxG.save.data.checkForUpdates = checkForUpdates;
	
		FlxG.save.flush();

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'ninjamuffin99'); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = keyBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs() {
		if(FlxG.save.data.downScroll != null) {
			downScroll = FlxG.save.data.downScroll;
		}
		if(FlxG.save.data.middleScroll != null) {
			middleScroll = FlxG.save.data.middleScroll;
		}
		if(FlxG.save.data.showFPS != null) {
			showFPS = FlxG.save.data.showFPS;
			if(Main.fpsVar != null) {
				Main.fpsVar.visible = showFPS;
			}
		}
		if(FlxG.save.data.flashing != null) {
			flashing = FlxG.save.data.flashing;
		}
		if(FlxG.save.data.holdNoteVisibility != null) {
			holdNoteVisibility = FlxG.save.data.holdNoteVisibility;
		}
		if(FlxG.save.data.globalAntialiasing != null) {
			globalAntialiasing = FlxG.save.data.globalAntialiasing;
		}
		if(FlxG.save.data.colorblindMode != null) {
			colorblindMode = FlxG.save.data.colorblindMode;
		}
		if(FlxG.save.data.opponentStrums != null) {
			opponentStrums = FlxG.save.data.opponentStrums;
		}
		if(FlxG.save.data.noteSplashes != null) {
			noteSplashes = FlxG.save.data.noteSplashes;
		}
		if(FlxG.save.data.lowQuality != null) {
			lowQuality = FlxG.save.data.lowQuality;
		}
		if(FlxG.save.data.characterTrail != null) {
			characterTrail = FlxG.save.data.characterTrail;
		}
		if(FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}
		if(FlxG.save.data.iconbops != null) {
			iconbops = FlxG.save.data.iconbops;
		}
		if(FlxG.save.data.autosaveInterval != null) {
			autosaveInterval = FlxG.save.data.autosaveInterval;
		}
		if(FlxG.save.data.autosavecharts != null) {
			autosavecharts = FlxG.save.data.autosavecharts;
		}
		if(FlxG.save.data.themedmainmenubg != null) {
			themedmainmenubg = FlxG.save.data.themedmainmenubg;
		}
		if(FlxG.save.data.autotitleskip != null) {
			autotitleskip = FlxG.save.data.autotitleskip;
		}
		/*if(FlxG.save.data.cursing != null) {
			cursing = FlxG.save.data.cursing;
		}
		if(FlxG.save.data.violence != null) {
			violence = FlxG.save.data.violence;
		}*/
		if(FlxG.save.data.camZooms != null) {
			camZooms = FlxG.save.data.camZooms;
		}
		if(FlxG.save.data.hideHud != null) {
			hideHud = FlxG.save.data.hideHud;
		}
		if(FlxG.save.data.hideWatermark != null) {
			hideWatermark = FlxG.save.data.hideWatermark;
		}
		if(FlxG.save.data.hideWatermark != null) {
			hideScoreText = FlxG.save.data.hideScoreText;
		}
		if(FlxG.save.data.noteOffset != null) {
			noteOffset = FlxG.save.data.noteOffset;
		}
		if(FlxG.save.data.showcaseMode != null) {
			showcaseMode = FlxG.save.data.showcaseMode;
		}
		if(FlxG.save.data.arrowHSV != null) {
			arrowHSV = FlxG.save.data.arrowHSV;
		}
		if(FlxG.save.data.ghostTapping != null) {
			ghostTapping = FlxG.save.data.ghostTapping;
		}
		if(FlxG.save.data.timeBarType != null) {
			timeBarType = FlxG.save.data.timeBarType;
		}
		if(FlxG.save.data.scoreZoom != null) {
			scoreZoom = FlxG.save.data.scoreZoom;
		}
		if(FlxG.save.data.noReset != null) {
			noReset = FlxG.save.data.noReset;
		}
		if(FlxG.save.data.showMsText != null) {
			showMsText = FlxG.save.data.showMsText;
		}
		if(FlxG.save.data.healthBarAlpha != null) {
			healthBarAlpha = FlxG.save.data.healthBarAlpha;
		}
		if(FlxG.save.data.comboOffset != null) {
			comboOffset = FlxG.save.data.comboOffset;
		}
		if(FlxG.save.data.ratingOffset != null) {
			ratingOffset = FlxG.save.data.ratingOffset;
		}
		if(FlxG.save.data.hitWindowPreset != null) {
			hitWindowPreset = FlxG.save.data.hitWindowPreset;
		}
			if(FlxG.save.data.marvWindow != null) {
				marvWindow = FlxG.save.data.marvWindow;
			}
			if(FlxG.save.data.perfWindow != null) {
				perfWindow = FlxG.save.data.perfWindow;
			}
			if(FlxG.save.data.greatWindow != null) {
				greatWindow = FlxG.save.data.greatWindow;
			}
			if(FlxG.save.data.goodWindow != null) {
				goodWindow = FlxG.save.data.goodWindow;
			}
			if(FlxG.save.data.okWindow != null) {
				okWindow = FlxG.save.data.okWindow;
			}
		if(FlxG.save.data.safeFrames != null) {
			safeFrames = FlxG.save.data.safeFrames;
		}
		if(FlxG.save.data.controllerMode != null) {
			controllerMode = FlxG.save.data.controllerMode;
		}
		if(FlxG.save.data.hitsoundVolume != null) {
			hitsoundVolume = FlxG.save.data.hitsoundVolume;
		}
		if(FlxG.save.data.cameramoveonnotes != null) {
			cameramoveonnotes = FlxG.save.data.cameramoveonnotes;
		}
		if(FlxG.save.data.underlaneVisibility != null) {
			underlaneVisibility = FlxG.save.data.underlaneVisibility;
		}
		if(FlxG.save.data.OpponentUnderlaneVisibility != null) {
			opponentUnderlaneVisibility = FlxG.save.data.OpponentUnderlaneVisibility;
		}
		if(FlxG.save.data.pauseMusic != null) {
			pauseMusic = FlxG.save.data.pauseMusic;
		}
		if(FlxG.save.data.noteSkinSettings != null) {
			noteSkinSettings = FlxG.save.data.noteSkinSettings;
		}
		if(FlxG.save.data.gameplaySettings != null)
		{
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
			{
				gameplaySettings.set(name, value);
			}
		}
		
		// flixel automatically saves your volume!
		if(FlxG.save.data.volume != null)
		{
			FlxG.sound.volume = FlxG.save.data.volume;
		}
		if (FlxG.save.data.mute != null)
		{
			FlxG.sound.muted = FlxG.save.data.mute;
		}
		if (FlxG.save.data.checkForUpdates != null)
		{
			checkForUpdates = FlxG.save.data.checkForUpdates;
		}

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'ninjamuffin99');
		if(save != null && save.data.customControls != null) {
			var loadedControls:Map<String, Array<FlxKey>> = save.data.customControls;
			for (control => keys in loadedControls) {
				keyBinds.set(control, keys);
			}
			reloadControls();
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic):Dynamic {
		return /*PlayState.isStoryMode ? defaultValue : */ (gameplaySettings.exists(name) ? gameplaySettings.get(name) : defaultValue);
	}

	public static function reloadControls() {
		PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);

		TitleState.muteKeys = copyKey(keyBinds.get('volume_mute'));
		TitleState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		TitleState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
	}
	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey> {
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len) {
			if(copiedArray[i] == NONE) {
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}
}
