package options;

import flixel.util.FlxStringUtil;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;

import Achievements;

using StringTools;

class CodeInputState extends MusicBeatState //i copied this from note offset state so idk if removin somethin will break it
{
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;

	public var codeDisplay:FlxText;
	private var currentcode:String = '';
	private var canInput:Bool = false;
	private var underscoreThing:String = '';
	private var resetThing:Int = 0;

	var prefix:String = 'PS C:\\fnf-cal.mod-source.code\\export\\release\\windows\\bin> ';

	public var outputDisplay:FlxText;

	override public function create()
	{
		// Cameras
		FlxG.mouse.visible = true;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camGame.bgColor = 0xFF000C18;
		if(Main.fpsVar != null) Main.fpsVar.visible = false;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		camHUD.y += 500;

		FlxCamera.defaultCameras = [camGame];
		CustomFadeTransition.nextCamera = camOther;

		codeDisplay = new FlxText(0,0,FlxG.width, prefix, 16);
		codeDisplay.setFormat(Paths.font("lucida.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		codeDisplay.screenCenter(X);

		outputDisplay = new FlxText(0,codeDisplay.height,FlxG.width,'', 16);
		outputDisplay.setFormat(Paths.font("lucida.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		outputDisplay.screenCenter(X);
		outputDisplay.alpha = 0;

		persistentUpdate = true;
		FlxG.sound.pause();
		super.create();

		new FlxTimer().start(1, tmr->{
			add(codeDisplay);
			add(outputDisplay);
			canInput = true;
		});

		new FlxTimer().start(0.5, tmr2->{underscoreThing = (underscoreThing == '_') ? '' : '_';}, 0);
	}

	override public function update(elapsed:Float) //also this is stupidly done dont blame me idk what the fuck im doing lmao
	{
		if (FlxG.keys.firstJustPressed() != -1 && canInput) {
			switch (FlxG.keys.firstJustPressed()) {
				case 8:
					if (currentcode.length > 0) currentcode = currentcode.substring(0, currentcode.length -1);
				case 13:
					canInput = false;
					new FlxTimer().start(0.25, tmr->{checkCode();});
				case 27:
					canInput = false;
					bye();
				case 32:
					currentcode = currentcode + ' '; //bruh
				case 190:
					currentcode = currentcode + '.'; //bruh 2
				default:
					if (FlxKey.toStringMap[FlxG.keys.firstJustPressed()].length == 1) { //check if its a letter
					currentcode = currentcode + FlxKey.toStringMap[FlxG.keys.firstJustPressed()].toLowerCase();}
					else if (FlxMath.inBounds(FlxG.keys.firstJustPressed(), 48, 57)) { //check if its a number
						currentcode = currentcode + Std.string(FlxG.keys.firstJustPressed() -48);
					}
			}
		}

		if (!canInput) underscoreThing = '';
		codeDisplay.text = prefix + currentcode + underscoreThing;

		super.update(elapsed);
	}

	function bye() {

		persistentUpdate = false;
		CustomFadeTransition.nextCamera = camOther;
		MusicBeatState.switchState(new MainMenuState());
		FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
	}

	function checkCode() { //heavily optimized this bullshit, prev one sucked ass

		switch(currentcode.toLowerCase())
		{
/* 			case 'abetterplace': //unlock a song for lumi?
				// go back to this later

			case 'z': //idk
				// do something

			case 'alightintheshadows': //unlock a song for purp?
				// go back to this later
 */
			case 'sys.exit': //clear progress data
				outputDisplay.alpha = 1;
				switch (resetThing++) {
					case 0:
						outputDisplay.text = 'source/options/CodeInputState.hx:134: This action will clear your saved progress data, and close the game.\nAre you sure you want to proceed? (repeat to confirm)';
						new FlxTimer().start(0.5, tmr->{canInput = true; currentcode = ''; new FlxTimer().start(5, tmr->{FlxTween.tween(outputDisplay, {alpha: 0}, 0.25);});});
						return;
					case 1:
						outputDisplay.text = 'source/options/CodeInputState.hx:138: Once you do this, it cannot be undone. Are you 100% sure?\n(repeat to confirm)';
						new FlxTimer().start(0.5, tmr->{canInput = true; currentcode = ''; new FlxTimer().start(5, tmr->{FlxTween.tween(outputDisplay, {alpha: 0}, 0.25);});});
						return;
					case 2:
						outputDisplay.text = 'source/options/CodeInputState.hx:142: Goodbye...';
						FlxTween.tween(camGame, {alpha: 0}, 5, {onComplete: resetProgress});
						return;
				}
/* 			case 'x': //idk
				// do something 
 */
			case 'kkclue':
				CoolUtil.browserLoad('https://youtu.be/4RNraJmO4BY');
				outputDisplay.text = 'source/options/CodeInputState.hx:151: this guy gave me a beta of the code idea after watching this video';
				new FlxTimer().start(0.5, tmr->{canInput = true; currentcode = ''; new FlxTimer().start(5, tmr->{FlxTween.tween(outputDisplay, {alpha: 0}, 0.25);});});

			case 'lime test windows': //achievement
				#if ACHIEVEMENTS_ALLOWED
				Achievements.loadAchievements();
				var achieveID:Int = Achievements.getAchievementIndex('password');
				if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) {
					Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
					giveAchievement();
					ClientPrefs.saveSettings();
				} else {
					resetCode(1);
					return;
				}
				#else
				resetCode(1);
				return;
				#end

			default: //not a valid code, bail out
				resetCode(65536);
				return;
		}
		resetCode(0);
	}

	function resetCode(variant:Int = 0) {
		outputDisplay.alpha = 1;
		resetThing = 0;

		switch(variant) {
			case 0:
				outputDisplay.text = 'source/options/CodeInputState.hx:174: Code accepted!';
			case 1:
				outputDisplay.text = 'source/options/CodeInputState.hx:184: lines 184-185 : Warning : This case is unused';				
			default:
				outputDisplay.text = 'source/options/CodeInputState.hx:171: characters 5-' + (5 + currentcode.length) + ' : Unknown identifier : $currentcode';
		}
		currentcode = '';

		new FlxTimer().start(1.5, tmr->{FlxTween.tween(outputDisplay, {alpha: 0}, 0.25);});
		new FlxTimer().start(0.33, tmr->{canInput = true;});
	}

	#if ACHIEVEMENTS_ALLOWED
	function giveAchievement() {
		add(new AchievementObject('password', camHUD));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('yoooo');
	}
	#end
	
	private static function resetProgress(tween:FlxTween) {
		 //im not responsible of any progress you lose
		FlxG.save.data.achievementsMap = null;
		FlxG.save.data.henchmenDeath = null;
		FlxG.save.data.totalScore = null;
		FlxG.save.data.songRating = null;
		FlxG.save.data.songScores = null;
		FlxG.save.data.weekScores = null;
		FlxG.save.flush();
		FlxG.sound.pause();
		trace('bye bye');
		Sys.exit(2);
	}

	private function loadSong(song:String, ?arg:String) {

		var songLow:String = Paths.formatToSongPath(song);
		persistentUpdate = false;

		PlayState.SONG = Song.loadFromJson(Highscore.formatSong(songLow, 2), songLow);
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = 2;

		switch (arg) {
			default:
				// idk lmao
		}
	}
}
