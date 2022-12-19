package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import ColorblindFilters;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var osEngineVersion:String = '1.5.1'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<MenuOption>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'editor',
		'awards',
		'options',
		'credits'
	];

	var magenta:FlxSprite;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	override function create()
	{
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end

		ClientPrefs.loadPrefs();

		WeekData.loadTheFirstEnabledMod();
		if (ClientPrefs.colorblindMode != null) ColorblindFilters.applyFiltersOnGame(); // applies colorbind filters, ok?

		#if desktop
		// Updating Discord Rich Presence

		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
		FlxG.mouse.visible = true;

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];
		//camera.zoom = 1.85;

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
        var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
        bg.scrollFactor.set(0, yScroll);
        bg.setGraphicSize(Std.int(bg.width));
        bg.updateHitbox();
        bg.screenCenter();
        bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.alpha = 0.25;
        add(bg);

        if(ClientPrefs.themedmainmenubg == true) {

            var themedBg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
            themedBg.scrollFactor.set(0, yScroll);
            themedBg.setGraphicSize(Std.int(bg.width));
            themedBg.updateHitbox();
            themedBg.screenCenter();
            themedBg.antialiasing = ClientPrefs.globalAntialiasing;
			themedBg.alpha = 0.25;
            add(themedBg);

            var hours:Int = Date.now().getHours();
            if(hours > 18) {
                themedBg.color = 0x545f8a; // 0x6939ff
            } else if(hours > 8) {
                themedBg.loadGraphic(Paths.image('menuBG'));
            }
        }

        magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
        magenta.scrollFactor.set(0, yScroll);
        magenta.setGraphicSize(Std.int(magenta.width));
        magenta.updateHitbox();
        magenta.screenCenter();
        magenta.visible = false;
        magenta.antialiasing = ClientPrefs.globalAntialiasing;
        magenta.color = 0xFFfd719b;
		magenta.alpha = 0.25;
        add(magenta);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<MenuOption>();
		add(menuItems);

		var scale:Float = 0.7;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		var curoffset:Float = 100;

		// { region things
		var menuPlay:MenuOption = new MenuOption((FlxG.width /2) - (150 * scale), 300, 'play', scale);
		menuPlay.ID = 0;
		menuPlay.scrollFactor.set();
		menuPlay.screenCenter(X);
		menuItems.add(menuPlay);

		var menuEdit:MenuOption = new MenuOption((FlxG.width /4) - (137.5 * scale), 300, 'editor', scale);
		menuEdit.ID = 1;
		menuEdit.scrollFactor.set();
		menuEdit.screenCenter(X);
		menuEdit.x -= FlxG.width /4;
		menuItems.add(menuEdit);

		#if ACHIEVEMENTS_ALLOWED
		var menuAwards:MenuOption = new MenuOption(0, 0, 'awards', scale * 0.8, true);
		menuAwards.ID = 2;
		menuAwards.scrollFactor.set();
		menuItems.add(menuAwards);
		#end

		var menuOptions:MenuOption = new MenuOption((FlxG.width * 0.75) - (137.5 * scale), 300, 'options', scale);
		menuOptions.ID = 3;
		menuOptions.scrollFactor.set();
		menuOptions.screenCenter(X);
		menuOptions.x += FlxG.width /4;
		menuItems.add(menuOptions);

		var menuCredits:MenuOption = new MenuOption((FlxG.width) - 150, 0, 'credits', scale * 0.8, true);
		menuCredits.ID = 4;
		menuCredits.scrollFactor.set();
		menuItems.add(menuCredits);
		// } endregion

		camFollowPos = new FlxObject(menuPlay.getGraphicMidpoint().x, menuPlay.getGraphicMidpoint().y, 1, 1);
        add(camFollowPos);

		FlxG.camera.follow(camFollowPos, null, 1);

		// { region more things
		var versionShit:FlxText = new FlxText(FlxG.width * 0.7, FlxG.height - 64, 0, "OS Engine v" + osEngineVersion + " - Modded Psych Engine", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(FlxG.width * 0.7, FlxG.height - 44, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(FlxG.width * 0.7, FlxG.height - 24, 0, "Accuracy+ Patch v0.5", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var buttonText:FlxText = new FlxText(0, menuPlay.y + 250, 0, "Start", 12);
		buttonText.screenCenter(X);
		buttonText.x -= 30;
		buttonText.scrollFactor.set();
		buttonText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
		add(buttonText);
		var buttonText:FlxText = new FlxText(0, menuEdit.y + 200, 0, "Edit", 12);
		buttonText.screenCenter(X);
		buttonText.x -= FlxG.width /4 + 20;
		buttonText.scrollFactor.set();
		buttonText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
		add(buttonText);
		var buttonText:FlxText = new FlxText(0, menuOptions.y + 200, 0, "Options", 12);
		buttonText.screenCenter(X);
		buttonText.x += FlxG.width /4 - 40;
		buttonText.scrollFactor.set();
		buttonText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
		add(buttonText);

		var importantStuff:FlxText = new FlxText(12, FlxG.height - 60, 0, "This product is not affiliated with Cats are Liquid or its owner Last Quarter Studios Limited Partnership,", 12);
		importantStuff.scrollFactor.set();
		importantStuff.setFormat("VCR OSD Mono", 12, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		importantStuff.screenCenter(X);
		importantStuff.alpha = 0.5;
		importantStuff.x -= 200;
		add(importantStuff); //copyright stuff

		var importantStuff:FlxText = new FlxText(12, FlxG.height - 45, 0, "and is not endorsed or in any way otherwise sponsored by Last Quarter Studios.", 12);
		importantStuff.scrollFactor.set();
		importantStuff.setFormat("VCR OSD Mono", 12, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		importantStuff.screenCenter(X);
		importantStuff.alpha = 0.5;
		importantStuff.x -= 200;
		add(importantStuff); // I DONT WANT THE FKIN BIG GAP BETWEEN LINES

		var importantStuff:FlxText = new FlxText(12, FlxG.height - 30, 0, "Portions of the materials contained within this product are property of Last Quarter Studios Limited Partnership.", 12);
		importantStuff.scrollFactor.set();
		importantStuff.setFormat("VCR OSD Mono", 12, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		importantStuff.screenCenter(X);
		importantStuff.alpha = 0.5;
		importantStuff.x -= 200;
		add(importantStuff); // thanks lqd for telling me these stuff
		// } endregion
		
		// NG.core.calls.event.logEvent('swag').send();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;


	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);

		/* if (FlxG.mouse.justPressed) trace(FlxG.mouse.x + ', ' + FlxG.mouse.y); */

		if (!selectedSomethin)
		{
			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}
			else if (FlxG.keys.pressed.NINE) {
				LoadingState.loadAndSwitchState(new options.CodeInputState());
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:MenuOption)
		{
			if (!selectedSomethin) {
				if (FlxG.mouse.overlaps(spr)) {
					if (curSelected != spr.ID) curSelected = spr.ID;
					if (FlxG.mouse.justPressed) advance();
				}
			}
		});
	}

	function advance() 
	{
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));

		if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

		menuItems.forEach(function(spr:MenuOption)
		{
			if (curSelected != spr.ID)
			{
				FlxTween.tween(spr, {x: -500}, 2, {ease: FlxEase.backInOut, type: ONESHOT, onComplete: function(twn:FlxTween) {
					spr.kill();
				}});
			}
			else
			{
				FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)

				{
					var daChoice:String = optionShit[curSelected];

					switch (daChoice)
					{
						case 'story_mode':
							MusicBeatState.switchState(new FreeplayState());
						case 'editor':
							MusicBeatState.switchState(new MasterEditorMenu());
						case 'awards':
							MusicBeatState.switchState(new AchievementsMenuState());
						case 'options':
							LoadingState.loadAndSwitchState(new options.OptionsState());
						case 'credits':
							MusicBeatState.switchState(new CreditsState());
					}
				});
			}
		});
	}
}

class MenuOption extends FlxSprite 
{
	private var isSingle:Bool = false; //lmao

	public function new(x:Float, y:Float, sprite:String, ?scale:Float = 1.0, ?isSingle:Bool = false)
	{
		super(x, y);
		this.scale.x = scale;
		this.scale.y = scale;
		this.isSingle = isSingle;
		if (isSingle) {
			this.loadGraphic(Paths.image('mainmenu/' + sprite));
			this.alpha = 0.5;
		}
		else {
			this.frames = Paths.getSparrowAtlas('mainmenu/' + sprite);
			this.animation.addByPrefix('idle','idle', 24);
			this.animation.addByPrefix('selecting','selecting', 60, false);
			this.animation.addByPrefix('selected','selected', 24);
			this.animation.addByPrefix('deselecting','deselecting', 60, false);
			this.animation.play('idle');
		}
		this.scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		if (this.isSingle) {
			if (FlxG.mouse.overlaps(this)) {
				if (this.alpha < 1.0) this.alpha += 0.05;
			} else if (this.alpha > 0.5) this.alpha -= 0.05;
		} else {
			if (animation.curAnim.finished) {
				if (animation.curAnim.name == 'selecting') 	this.animation.play('selected');
				else if (animation.curAnim.name == 'deselecting') this.animation.play('idle');
			}

			if (FlxG.mouse.overlaps(this)) {
				if (this.animation.curAnim.name == 'deselecting' || this.animation.curAnim.name == 'idle') this.animation.play('selecting');
			} else {
				if (this.animation.curAnim.name == 'selecting' || this.animation.curAnim.name == 'selected') this.animation.play('deselecting');
			}
		}
		
		super.update(elapsed);
	}
}
