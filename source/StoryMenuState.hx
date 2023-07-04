package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
import WeekData;

using StringTools;

class StoryMenuState extends MusicBeatState
{

   	// TODO: pls just work on story menu for once
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();

	private static var lastDifficultyName:String = '';
	public static var curDifficulty:Int = 1;

	//var bgSprite:FlxSprite;

	private static var curWeek:Int = 0;
	public static var weekMouseY:Float = 0;
	public static var remoteTrigger:Int = -1;

	var grpWeekText:FlxTypedGroup<WeekCard>;
	//var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var debug:FlxText;

	var backArrow:MenuArrow;
	var freeplayArrow:MenuArrow;

	var hm:FlxTypedGroup<MenuArrow>;

	var loadedWeeks:Array<WeekData> = [];

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		FlxG.mouse.visible = true;

		PlayState.isStoryMode = true;
		WeekData.reloadWeekFiles(true);
		if(curWeek >= WeekData.weeksList.length) curWeek = 0;
		persistentUpdate = persistentDraw = true;

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		//var bgYellow:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 386, 0xFFF9CF51);
		//bgSprite = new FlxSprite(0, 56);
		//bgSprite.antialiasing = ClientPrefs.globalAntialiasing;

		grpWeekText = new FlxTypedGroup<WeekCard>();
		add(grpWeekText);

/* 		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
        bg.scrollFactor.set(0, 0.2);
        bg.setGraphicSize(Std.int(bg.width));
        bg.updateHitbox();
        bg.screenCenter();
        bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.alpha = 0.15;
        add(bg);
		bg.y+=10;

        if(ClientPrefs.themedmainmenubg == true) {

            var themedBg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
            themedBg.scrollFactor.set(0, 0.2);
            themedBg.setGraphicSize(Std.int(bg.width));
            themedBg.updateHitbox();
            themedBg.screenCenter();
            themedBg.antialiasing = ClientPrefs.globalAntialiasing;
			themedBg.alpha = 0.15;
            add(themedBg);
			themedBg.y+=10;
			bg.visible = false;

            var hours:Int = Date.now().getHours();
            if(hours > 18) {
                themedBg.color = 0x545f8a; // 0x6939ff
            } else if(hours > 8) {
                themedBg.loadGraphic(Paths.image('menuBG'));
            }
        } */

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var num:Int = 0;
		for (i in 0...WeekData.weeksList.length)
		{
			var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var isLocked:Bool = weekIsLocked(WeekData.weeksList[i]);
			if(!isLocked || !weekFile.hiddenUntilUnlocked)
			{
				loadedWeeks.push(weekFile);
				WeekData.setDirectoryFromWeek(weekFile);
/* 				var weekThing:MenuItem = new MenuItem(0, 56 + 396, WeekData.weeksList[i]);
				weekThing.y += ((weekThing.height + 20) * num);
				weekThing.targetY = num;
				grpWeekText.add(weekThing);

				weekThing.screenCenter(X);
				weekThing.antialiasing = ClientPrefs.globalAntialiasing;
				// weekThing.updateHitbox();

				// Needs an offset thingie
				if (isLocked)
				{
					var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
					lock.frames = ui_tex;
					lock.animation.addByPrefix('lock', 'lock');
					lock.animation.play('lock');
					lock.ID = i;
					lock.antialiasing = ClientPrefs.globalAntialiasing;
					grpLocks.add(lock);
				}
				num++; */ //commented it cuz im totally gonna fuck it up
				var weekCard:WeekCard = new WeekCard(0, 0, i, loadedWeeks[i]);
				weekCard.screenCenter();
				//weekCard.y += ((weekCard.height +20) * num);
				weekCard.targetY = num;
				weekCard.score = Highscore.getWeekScore(loadedWeeks[i].fileName, curDifficulty);
				grpWeekText.add(weekCard);
				weekCard.antialiasing = ClientPrefs.globalAntialiasing;

				if (isLocked)
					{
						var lock:FlxSprite = new FlxSprite(weekCard.width - 50 + weekCard.x);
						lock.frames = ui_tex;
						lock.animation.addByPrefix('lock', 'lock');
						lock.animation.play('lock');
						lock.ID = i;
						lock.antialiasing = ClientPrefs.globalAntialiasing;
						grpLocks.add(lock);
						trace('lock created');
					}

				num++;
			}
		}

		WeekData.setDirectoryFromWeek(loadedWeeks[0]);
		/*var charArray:Array<String> = loadedWeeks[0].weekCharacters;
		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, charArray[char]);
			weekCharacterThing.y += 70;
			grpWeekCharacters.add(weekCharacterThing);
		}*/

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		sprDifficulty = new FlxSprite(0,0);
		sprDifficulty.antialiasing = ClientPrefs.globalAntialiasing;
		sprDifficulty.scale.x = 0.8;
		sprDifficulty.scale.y = 0.8;
		sprDifficulty.updateHitbox();
		sprDifficulty.screenCenter(X);
		difficultySelectors.add(sprDifficulty);

		/* leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10); */
		leftArrow = new FlxSprite(0,0);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
		leftArrow.scale.x = 0.8;
		leftArrow.scale.y = 0.8;
		leftArrow.updateHitbox();
		difficultySelectors.add(leftArrow);

		sprDifficulty.y = leftArrow.y + 10;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		if(lastDifficultyName == '')
		{
			lastDifficultyName = 'Hard';
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));

		rightArrow = new FlxSprite(0,0);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.antialiasing = ClientPrefs.globalAntialiasing;
		rightArrow.scale.x = 0.8;
		rightArrow.scale.y = 0.8;
		rightArrow.updateHitbox();
		difficultySelectors.add(rightArrow);

		backArrow = new MenuArrow(20, 0, '', 0.65);
		backArrow.screenCenter(XY); backArrow.x -= FlxG.width /2.25;
		freeplayArrow = new MenuArrow(FlxG.width - 236, 0, 'Freeplay', 0.65);
		freeplayArrow.screenCenter(XY); freeplayArrow.x += FlxG.width /2.25;
		hm = new FlxTypedGroup<MenuArrow>();
		hm.add(backArrow);
		hm.add(freeplayArrow);

		add(hm);
		//add(bgYellow);
		//add(bgSprite);
		//add(grpWeekCharacters);

		changeWeek();
		changeDifficulty();

		super.create();
	}

	override function closeSubState() {
		persistentUpdate = true;
		changeWeek();
		super.closeSubState();
	}

	override function update(elapsed:Float)
	{
		if (!movedBack && !selectedWeek)
		{
			var upP = controls.UI_UP_P;
			var downP = controls.UI_DOWN_P;
			if (upP)
			{
				changeWeek(-1);
				weekMouseY = curWeek;
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (downP)
			{
				changeWeek(1);
				weekMouseY = curWeek;
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if(FlxG.mouse.wheel != 0)
			{
				//FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				//changeWeek(-FlxG.mouse.wheel);
				weekMouseY += -FlxG.mouse.wheel / 8;
				if (weekMouseY < 0) weekMouseY = 0; else if (weekMouseY > loadedWeeks.length - 1) weekMouseY = loadedWeeks.length - 1;
				if (Math.round(weekMouseY) != curWeek) changeWeek(Math.round(weekMouseY) - curWeek); changeDifficulty();
			}

			if (controls.UI_RIGHT)
				rightArrow.animation.play('press')
			else
				rightArrow.animation.play('idle');

			if (controls.UI_LEFT)
				leftArrow.animation.play('press');
			else
				leftArrow.animation.play('idle');

			if (controls.UI_RIGHT_P)
				changeDifficulty(1);
			else if (controls.UI_LEFT_P)
				changeDifficulty(-1);
			else if (upP || downP)
				changeDifficulty();

			if(FlxG.keys.justPressed.CONTROL)
			{
				persistentUpdate = false;
				trace('this somehow only works with a trace');
				openSubState(new GameplayChangersSubstate());
			}
			else if(controls.RESET)
			{
				persistentUpdate = false;
				openSubState(new ResetScoreSubState('', curDifficulty, '', curWeek));
				//FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			else if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			MusicBeatState.switchState(new MainMenuState());
		}

		if (FlxG.mouse.justPressed) {
			if (FlxG.mouse.overlaps(hm)) {
				movedBack = true;
			}
		}

		super.update(elapsed);

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
			//lock.visible = (lock.y > FlxG.height / 2);
		});

		if (remoteTrigger >= 0) {
			curWeek = remoteTrigger;
			weekMouseY = remoteTrigger;
			changeWeek();
			selectWeek();
			remoteTrigger = -1;
		}
	}

	var movedBack:Bool = false;
	public static var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (!weekIsLocked(loadedWeeks[curWeek].fileName))
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				//grpWeekText.members[curWeek].startFlashing();

				/*var bf:MenuCharacter = grpWeekCharacters.members[1];
				if(bf.character != '' && bf.hasConfirmAnimation) grpWeekCharacters.members[1].animation.play('confirm');*/
				stopspamming = true;
			}

			// We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.
			var songArray:Array<String> = [];
			var leWeek:Array<Dynamic> = loadedWeeks[curWeek].songs;
			for (i in 0...leWeek.length) {
				songArray.push(leWeek[i][0]);
			}

			// Nevermind that's stupid lmao
			PlayState.storyPlaylist = songArray;
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = CoolUtil.getDifficultyFilePath(curDifficulty);
			if(diffic == null) diffic = '';

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
				FreeplayState.destroyFreeplayVocals();
			});
		} else {
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
	}

	var tweenDifficulty:FlxTween;
	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		WeekData.setDirectoryFromWeek(loadedWeeks[curWeek]);

		var diff:String = CoolUtil.difficulties[curDifficulty];
		var newImage:FlxGraphic = Paths.image('menudifficulties/' + Paths.formatToSongPath(diff));
		//trace(Paths.currentModDirectory + ', menudifficulties/' + Paths.formatToSongPath(diff));

		if(sprDifficulty.graphic != newImage)
		{
			sprDifficulty.loadGraphic(newImage);
			sprDifficulty.screenCenter(X);
			sprDifficulty.alpha = 0;
			leftArrow.x = sprDifficulty.x - leftArrow.width;
			rightArrow.x = sprDifficulty.x + sprDifficulty.width;

			if(tweenDifficulty != null) tweenDifficulty.cancel();
			tweenDifficulty = FlxTween.tween(sprDifficulty, {alpha: 1}, 0.07, {onComplete: function(twn:FlxTween)
			{
				tweenDifficulty = null;
			}});
		}
		lastDifficultyName = diff;

		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= loadedWeeks.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = loadedWeeks.length - 1;

		var leWeek:WeekData = loadedWeeks[curWeek];
		WeekData.setDirectoryFromWeek(leWeek);

		var leName:String = leWeek.storyName;

		var bullShit:Int = 0;

		var unlocked:Bool = !weekIsLocked(leWeek.fileName);
		/*
		bgSprite.visible = true;
		var assetName:String = leWeek.weekBackground;
		if(assetName == null || assetName.length < 1) {
			bgSprite.visible = false;
		} else {
			bgSprite.loadGraphic(Paths.image('menubackgrounds/menu_' + assetName));
		}
		*/
		PlayState.storyWeek = curWeek;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5
		difficultySelectors.visible = unlocked;

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
		updateText();
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}

	function updateText()
	{
		var leWeek:WeekData = loadedWeeks[curWeek];
		var stringThing:Array<String> = [];
		for (i in 0...leWeek.songs.length) {
			stringThing.push(leWeek.songs[i][0]);
		}

		#if !switch
		//intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		for (card in grpWeekText) card.score = Highscore.getWeekScore(card.data.fileName, curDifficulty);
		#end
	}
}

class MenuArrow extends FlxSprite // because im too lazy
{
	var type:String="";

	public function new(x:Float, y:Float, type:String, scale:Float = 1.0) { //y doesnt matter
		super(x, y);
		this.loadGraphic(Paths.image('storymenu/arrow' + type));
		this.scrollFactor.set();
		this.alpha = 0.5;
		this.type= type;
		this.screenCenter(Y);
		this.scale.x = scale;
		this.scale.y = scale;
		this.updateHitbox();
	}

	override function update(elapsed:Float) {
		if (FlxG.mouse.overlaps(this)) {
			if (this.alpha < 1.0) this.alpha += 0.05;
			if (FlxG.mouse.justPressed) {
				switch (type) {
					case 'Freeplay':
						FlxG.sound.play(Paths.sound('confirmMenu'));
						MusicBeatState.switchState(new FreeplayState());
					default:
						FlxG.sound.play(Paths.sound('cancelMenu'));
						MusicBeatState.switchState(new MainMenuState());
				}
			}
		} else if (this.alpha > 0.5) this.alpha -= 0.05;

		super.update(elapsed);
	}
}

class WeekCard extends FlxSpriteGroup
{
	var card:FlxSprite;
	
	var name:String = "";
	public var score:Int = -1;
	var lerpScore:Int = -1;
	var trackList:Array<Dynamic> = [];
	var songRanks:Array<String> = [];
	public var targetY:Float = 0;
	private var starUnlocked:Bool = false;
	var num:Int = 0;

	var nameDisplay:FlxText;
	var scoreDisplay:FlxText;
	var trackDisplay:FlxText;
	var accDisplay:FlxText;
	var songRankDisplay:FlxText;

	public var isActive:Bool = false;

	var button:FlxSprite;
	var star:FlxSprite;

	public var data(default,null):WeekData;

	final map:Array<Dynamic> = [
		['F', 0.6],
		['D', 0.7],
		['C', 0.8],
		['B', 0.9],
		['A', 0.95],
		['S', 0.99],
		['SS', 1],
		['X', 1]
	];

	public function new(x:Float, y:Float, weekNum:Int, data:WeekData, ?color:FlxColor = FlxColor.WHITE) {
		//mostly initialize variables
		super(x,y);
		this.data = data;
		this.name = data.weekName;
		for (b in data.songs) {
			this.trackList.push(b[0]);
		}
		this.score = Highscore.getWeekScore(data.fileName, StoryMenuState.curDifficulty);
		this.color = color;
		this.num = weekNum;

		card = new FlxSprite(0,0);
		card.loadGraphic(Paths.image('storymenu/card'));
		var a = data.songs[0][2];
		card.color = FlxColor.fromRGB(a[0],a[1],a[2], 255);

		button = new FlxSprite(675, 400);
		button.loadGraphic(Paths.image('storymenu/play'));

/* 		star = new FlxSprite(655, 15);
		star.loadGraphic(Paths.image('storymenu/star')); */

		nameDisplay = new FlxText(50, 20, 0, name, 32);
		nameDisplay.setFormat(Paths.font("phantommuff.ttf"), 48, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		nameDisplay.bold = true;

/* 		scoreDisplay = new FlxText(414, 441, 'Week Score: ' + StoryMenuState.lerpScore, 32); */
		scoreDisplay = new FlxText(nameDisplay.x, 0, 0,'Week Score: ' + score, 32);
		scoreDisplay.setFormat(Paths.font("phantommuff.ttf"), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		scoreDisplay.y = button.y + (button.height/2) - (scoreDisplay.height/2);

		trackDisplay = new FlxText(0, 140, 0, trackList.join('\n'), 32);
		trackDisplay.setFormat(Paths.font("phantommuff.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		trackDisplay.x = (card.width/2) - (trackDisplay.width/2);

		this.add(card);
		this.add(button);
//		this.add(star); not yet
		this.add(nameDisplay);
		this.add(scoreDisplay);
		this.add(trackDisplay);
	}

	override function update(elapsed) {
		super.update(elapsed);

		y = FlxMath.lerp(y, (((num - StoryMenuState.weekMouseY) * 640)) + (card.height/4), CoolUtil.boundTo(elapsed * 10.2, 0, 1));

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, score, CoolUtil.boundTo(elapsed * 30, 0, 1)));
		if(Math.abs(score - lerpScore) < 10) lerpScore = score;

		if (FlxG.mouse.overlaps(button)) {
			if (button.alpha < 1.0) button.alpha += 0.05;
			if (FlxG.mouse.justPressed && !StoryMenuState.selectedWeek) {
				StoryMenuState.remoteTrigger = num;
			}
		} else if (button.alpha > 0.65) button.alpha -= 0.05;
	} 

	function reloadData(newData:WeekData, ?skipScore:Bool=false) {
		data = newData;
		name = data.weekName;
		trackList = [];
		for (b in data.songs) {
			trackList.push(b[0]);
		}
		if (!skipScore) score = Highscore.getWeekScore(data.fileName, StoryMenuState.curDifficulty);
		color = color;
	}
}