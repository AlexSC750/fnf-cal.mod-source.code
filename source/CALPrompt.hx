package;
import flixel.*;
import flixel.FlxSubState;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIPopup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxSpriteUtil;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class CALPrompt extends MusicBeatSubstate
{
    var prompt:FlxSpriteGroup;
    var body:FlxSprite;
    var options:Array<Dynamic>;
    var name:String = "";
    var desc:String = "";
    var optionGroup:FlxTypedGroup<FlxText>;
    var canChoose:Bool = true;

    public function new(name:String, desc:String, options:Array<Dynamic>) {
        super();
        
        this.name = name.toUpperCase();
        this.desc = desc;
        this.options = options;
    }

    override public function create() {
        super.create();

        if (options.length <= 0) options.push( ['Close', ()->{}] );

        prompt = new FlxSpriteGroup();
        optionGroup = new FlxTypedGroup<FlxText>();

        body = new FlxSprite(0,0).makeGraphic(Std.int(FlxG.width * 0.5), Std.int(FlxG.height * 0.33), FlxColor.TRANSPARENT);
        FlxSpriteUtil.drawRoundRect(body, 0, 0, FlxG.width * 0.5, FlxG.height * 0.33, 30, 30, FlxColor.WHITE);
        prompt.add(body);

        var nameTxt:FlxText = new FlxText(0, body.height /6, body.width, name, 24);
        nameTxt.bold = true;
        nameTxt.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.BLACK, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        nameTxt.x = body.width/2 - nameTxt.width/2;
        prompt.add(nameTxt);

        var descTxt:FlxText = new FlxText(0, body.height /2, body.width, desc, 16);
        descTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.BLACK, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
        descTxt.x = body.width/2 - descTxt.width/2;
        prompt.add(descTxt);

		trace(options.length-1);
        for (i in 0...options.length) {
            var choice:FlxText = new FlxText(0, body.y + body.height + 10,0, options[i][0]);
            choice.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
            choice.ID = i;
            choice.x = (((i+1) / (options.length+1)) * body.width) - (choice.width/2);
            optionGroup.add(choice);
            prompt.add(choice);
			trace('loop ' + i + "\nx: " + ((i+1) / (options.length+1)));
        }

        prompt.screenCenter(X);
        prompt.y = -prompt.height;

        add(prompt);
        FlxTween.tween(prompt, {y: (FlxG.height/2) - (prompt.height/2)}, 0.75, {onComplete: end->{canChoose = true;}, ease: FlxEase.smoothStepInOut});
    }   

    override function update(elapsed) {
        super.update(elapsed);

        for (thing in optionGroup) {
            if (FlxG.mouse.overlaps(thing)) {
                if (thing.alpha < 1.0) thing.alpha += 0.05;
                if (FlxG.mouse.justPressed && canChoose) {
                    canChoose = false;
                    options[optionGroup.members.indexOf(thing)][1]();
                    exit();
                }
            } else if (thing.alpha > 0.65) thing.alpha -= 0.05;
        }
    }

    function exit() {
        FlxTween.tween(prompt, {y: -prompt.height}, 0.75, {ease: FlxEase.smoothStepInOut, onComplete: done->{close();}});
    }
}