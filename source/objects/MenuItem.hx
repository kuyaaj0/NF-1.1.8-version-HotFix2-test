package objects;

class MenuItem extends FlxSprite
{
	public var targetY:Float = 0;

	public function new(x:Float, y:Float, weekName:String = '')
	{
		super(x, y);

		// Try loading atlas (PNG + XML)
		var atlas = Paths.getSparrowAtlas('storymenu/' + weekName);
		if (atlas != null)
		{
			frames = atlas;

			// 👇 No hardcoded animation names.
			// Just leave it to mods/custom code to call animation.play("whatever").
			// If no animation is explicitly set, play the *first* one available.
			if (animation.getNameList().length > 0)
				animation.play(animation.getNameList()[0]); // plays first anim in XML
		}
		else
		{
			// fallback PNG (if no XML exists)
			loadGraphic(Paths.image('storymenu/' + weekName));
		}

		antialiasing = ClientPrefs.data.antialiasing;
	}

	public var isFlashing(default, set):Bool = false;

	private var _flashingElapsed:Float = 0;
	final _flashColor = 0xFF33FFFF;
	final flashes_ps:Int = 6;

	public function set_isFlashing(value:Bool = true):Bool
	{
		isFlashing = value;
		_flashingElapsed = 0;
		color = (isFlashing) ? _flashColor : FlxColor.WHITE;
		return isFlashing;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		y = FlxMath.lerp((targetY * 120) + 480, y, Math.exp(-elapsed * 10.2));

		if (isFlashing)
		{
			_flashingElapsed += elapsed;
			color = (Math.floor(_flashingElapsed * FlxG.updateFramerate * flashes_ps) % 2 == 0)
				? _flashColor
				: FlxColor.WHITE;
		}
	}
}
