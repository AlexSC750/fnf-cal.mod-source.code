package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import ColorblindFilters;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class VisualsUISubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Visuals and UI';
		rpcTitle = 'Visuals & UI Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('HUD Style',
			'do i really need to explain this\n(Classis is Psych, OS is, well OS, and Custom is one I made myself)',
			'hudStyle',
			'string',
			'Classic',
			['Classic', 'OS', 'Custom']);
		addOption(option);

		var option:Option = new Option('Note Splashes',
			"If unchecked, hitting \"Sick!\" notes won't show particles.",
			'noteSplashes',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option("Showcase Mode",
			'If checked, hides entire HUD and enables botplay :D',
			'showcaseMode',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Hide Watermark',
			'If checked, hides watermark in left-bottom corner while playing song',
			'hideWatermark',
			'bool',
			false);
		addOption(option);

		/*
		var option:Option = new Option('Character Trail',
			'If checked, adds trail behind character like in thorns',
			'characterTrail',				shit lol. i made better finally
			'bool',
			false);
		addOption(option);
		*/

		var option:Option = new Option('Hide Score Text',
			'If checked, hides score, accuracy and misses text under health bar in song',
			'hideScoreText',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Icon Bop',
			'Classic is Vanilla FnF icons bops, OS is OS Engine icons bops',
			'iconbops',
			'string',
			'OS',
			['OS', 'Classic']);
		addOption(option);

		var option:Option = new Option('Time Bar:',
			"What should the Time Bar display?\n(NOTE: This will not be used if the OS HUD is selected.)",
			'timeBarType',
			'string',
			'Time Left',
			['Time Left', 'Time Elapsed', 'Song Name', 'OS Time Left', 'Disabled']);
		addOption(option);

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Camera Zooms',
			"If unchecked, the camera won't zoom in on a beat hit.",
			'camZooms',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Score Text Zoom on Hit',
			"If unchecked, disables the Score text zooming\neverytime you hit a note.",
			'scoreZoom',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Health Bar Transparency',
			'How much transparent should the health bar and icons be.',
			'healthBarAlpha',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		/*
		var option:Option = new Option('Auto Title Skip',
			'If checked, automatically skips the title state.',
			'autotitleskip',
			'bool',
			false);
		option.defaultValue = false;
		addOption(option);
		*/

		var option:Option = new Option('Note Skin',
			"What note skin do you prefer for playing?",
			'noteSkinSettings',
			'string',
			'Classic',
			['Classic', 'Circle', 'StepMania (Default)', 'Quaver (Arrow)', 'In The Groove', 'StepMania 5 (Etterna)', "CL's Project Mania"]);
		addOption(option);

		var option:Option = new Option('Change Note Colors', //Name
			'Takes you to the Note Colors menu. A bit wonky, but it works.', //Description
			'dummy', //Save data variable name
			'none', //Variable type
			null); //Default value
		addOption(option);
		option.onChange = onNoteColorCheck;

		var option:Option = new Option('Display Judgement Counters',
			"Toggles the things on the left that show your hits.",
			'displayJudges',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Judgement Counter Scale',
			"Change the size of the judgement counters. Simple enough.",
			'judgeScale',
			'float',
			0.75);
		addOption(option);
		option.scrollSpeed = 5;
		option.minValue = 0.25;
		option.maxValue = 1.5;
		option.changeValue = 0.05;
		option.decimals = 2;

		super();
	}

	function onNoteColorCheck()
		{
			openSubState(new options.NotesSubState());
		}
}