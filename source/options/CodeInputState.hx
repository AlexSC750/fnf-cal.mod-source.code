package options;

import flixel.util.FlxStringUtil;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.ui.FlxBar;
import flixel.math.FlxPoint;

import Achievements;

using StringTools;

class CodeInputState extends MusicBeatState //i copied this from note offset state so idk if removin somethin will break it
{
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;

	public var codedisplay:FlxText;
	var currentcode:String = '';

	public var warndisplay:FlxText;

	override public function create()
	{
		// Cameras
		FlxG.mouse.visible = true;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];
		CustomFadeTransition.nextCamera = camOther;

		// Stage
		var bg:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('shh/wasntbotheredtoaddtheactualtextbycode'));
		bg.setGraphicSize(0, FlxG.height);
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		codedisplay = new FlxText(600,270,FlxG.width,'[]', 16);
		codedisplay.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		codedisplay.screenCenter(X);
		warndisplay = new FlxText(600,333,FlxG.width,'', 16);
		warndisplay.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		warndisplay.screenCenter(X);
		add(codedisplay);
		add(warndisplay);

		persistentUpdate = true;
		FlxG.sound.pause();
		super.create();
	}

	override public function update(elapsed:Float)
	{
/* 		var controlArray:Array<Bool> = [
			FlxG.keys.justPressed.LEFT,
			FlxG.keys.justPressed.DOWN,
			FlxG.keys.justPressed.UP,
			FlxG.keys.justPressed.RIGHT,

			FlxG.keys.justPressed.BACKSPACE,
			FlxG.keys.justPressed.ENTER,
			FlxG.keys.justPressed.ESCAPE
		];

		if(controlArray.contains(true))
		{
			for (i in 0...controlArray.length)
			{
				if(controlArray[i])
				{
					warndisplay.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
					warndisplay.text = '';

					switch(i)
					{
						case 0:
							currentcode = currentcode + "L";
						case 1:
							currentcode = currentcode + "D";
						case 2:
							currentcode = currentcode + "U";
						case 3:
							currentcode = currentcode + "R";
						case 4:
							if (currentcode.length > 0) currentcode = currentcode.substring(0, currentcode.length -1);
						case 5:
							checkCode();
						case 6:
							bye();
					}
					codedisplay.text = '[$currentcode]';
					codedisplay.screenCenter(X);
				}
			}
		} */

		if (FlxG.keys.firstJustPressed() != -1) {
			switch (FlxG.keys.firstJustPressed()) {
				case 13:
					checkCode();
				case 27:
					bye();
				default:
					currentcode = currentcode + String.fromCharCode(FlxG.keys.firstJustPressed());
			}
		}

		super.update(elapsed);
	}

	function bye() {

		persistentUpdate = false;
		CustomFadeTransition.nextCamera = camOther;
		MusicBeatState.switchState(new MainMenuState());
		FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
	}

	function checkCode() {

		final codelist:Array<String> = [ //yes, these are all the codes. you're welcome.
			// 0 = L, 1 = D, 2 = U, 3 = R
			'DURLDRDDDURDDUUD', //lumi -> b16 -> b4
			'LLLRRRLR', //ddr2
			'DRLLDRDDDRLUDRLL', //purp -> b16 -> b4
			'RLUDRDUDR', // 32767(16) -> 302131213(4)
			'DLURLUDLR', //tkd
			'DULRDURLDRDDDUDD', // the user who i got the secret menu style and some of the codes from
			#if ACHIEVEMENTS_ALLOWED 'UUDDLRLR', #end //konami
		];

		for (i in codelist) {
			if(currentcode == i)
			{
				switch(codelist.indexOf(i))
				{
					case 0: //unlock a song?
						// go back to this later
					case 1: //idk
						// do something
					case 2: //unlock another song?
						// go back to this later
					case 3: //clear progress data
						openSubState(new Prompt('This action will clear your saved progress data, and close the game.\nAre you sure you want to proceed?', 0, function(){
							openSubState(new Prompt('Once you do this, it cannot be undone.\n\nAre you 100% sure?', 0, function(){
								resetProgress();
							}, null,false, 'YES!', 'no pls go back'));
						}, null,false, 'Yes.', 'actually no'));
					case 4: //idk
						// do something 
					case 5:
						CoolUtil.browserLoad('https://youtu.be/4RNraJmO4BY');
					case 6: //achievement
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
				}
				resetCode(0);
				return;
			}
		}
		resetCode(-1);
	}

	function resetCode(variant:Int = 0) {
		switch(variant) {
			case 0:
				warndisplay.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.GREEN, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				warndisplay.text = 'Code accepted!';
				FlxG.sound.play(Paths.sound('konamiJingle'), 0.7);
			case 1:
				warndisplay.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.YELLOW, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				warndisplay.text = 'Code failed to work.';
			default:
				warndisplay.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				warndisplay.text = 'Invalid code';
		}
		currentcode = '';
		codedisplay.text = '[]';
	}

	#if ACHIEVEMENTS_ALLOWED
	function giveAchievement() {
		add(new AchievementObject('password', camHUD));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('yoooo');
	}
	#end
	
	private static function resetProgress() {
		 //be careful for the love of god with this thing im not responsible of any progress you lose
		FlxG.save.data.achievementsMap = null;
		FlxG.save.data.henchmenDeath = null;
		FlxG.save.data.totalScore = null;
		FlxG.save.data.songRating = null;
		FlxG.save.data.songScores = null;
		FlxG.save.data.weekScores = null;
		FlxG.save.flush();
		FlxG.sound.pause();
		Sys.exit(2);
	}
}
