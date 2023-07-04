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

class DebugTestState extends MusicBeatState
{
    public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
    public var id:Int = 0;

    var options:Map<String, Void->Void>;

    var optionArray:Array<String> = ['welcome to the debug menu!', 'open new prompt', 'exit'];

    var pointer:FlxText;
    var textGroup:FlxTypedGroup<FlxText>;

    var promptArray:Array<Dynamic> = [
        ['Play Sound', ()->{FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);}],
        ['Give Achievement', ()->{}],
        ['Play Sound', ()->{FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);}],
        ['Exit', ()->{}]
    ];

    override public function create()
    {
        super.create();

        textGroup = new FlxTypedGroup<FlxText>();

        if(Main.fpsVar != null) Main.fpsVar.visible = false;

        promptArray[1][1] = ()->{ //this doesnt work during init :(
            #if ACHIEVEMENTS_ALLOWED
            Achievements.loadAchievements();
            var achieveID:Int = Achievements.getAchievementIndex('password');
            if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) {
                Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
                giveAchievement();
                ClientPrefs.saveSettings();
            } else {
                FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);
            }
            #else
            FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);
            #end
       }

        options = [
            'welcome to the debug menu!' => ()->{}, //not really an option but who cares
            'open new prompt' => ()->{openSubState(new CALPrompt('test 2', 'This is a test of the new prompt, in the CAL:ABP style.\nHow many choices can I fit in here?', promptArray));},
            'exit' => ()->{
                MusicBeatState.switchState(new MainMenuState());
                FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
            }];

        var j = 0;
        for (choice in optionArray) {
            var blep:FlxText = new FlxText(0, 0, 0, choice);
            blep.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            blep.y = j++ * blep.height;
            textGroup.add(blep);
        }

        pointer = new FlxText(0,0,0,'<');
        pointer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.BLACK, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
        pointer.x = textGroup.members[1].x + textGroup.members[1].width;
        pointer.y = textGroup.members[1].y;

        add(textGroup);
        add(pointer);
        
        id = updateID(0);
    }
    
    override function update(elapsed)
    {
        if (FlxG.keys.justPressed.UP && id >0) updateID(--id);
        if (FlxG.keys.justPressed.DOWN && id < optionArray.length-2) updateID(++id);

        if (FlxG.keys.justPressed.ENTER) {
            options[optionArray[id+1]]();
        }
    }

    function updateID(id) {
        pointer.x = pointer.x = textGroup.members[id+1].x + textGroup.members[id+1].width;
        pointer.y = textGroup.members[id+1].y;

        for (option in textGroup.members) {
            if (textGroup.members.indexOf(option)-1 == id) {
                option.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.BLACK, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
            } else {
                option.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            }
        }
        return id;
    }

    #if ACHIEVEMENTS_ALLOWED
	function giveAchievement() {
		add(new AchievementObject('password', camHUD));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('yoooo');
	}
	#end
}