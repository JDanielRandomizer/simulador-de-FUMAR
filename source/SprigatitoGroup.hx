// eu acho que o codigo do sprigatito vai ser meio grande
package;

import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.FlxG;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class SprigatitoGroup extends FlxGroup
{
    // FlxSprite
    public static var sprigatito:FlxSprite;
    public static var fumaca:FlxSprite;
    public static var explosao:FlxSprite;

    public static var sweat:FlxSprite;
    public static var pant:FlxSprite;

    // Bool
    public static var sprigatitoDead:Bool = false;
    
    // Int || Float
    public static var allValuesTimeFrame:Array<Float> = [
        0.0, // currentSpriSprite
        0.0, // intendSpriSprite
        0.0, // currentSmokeFrame
        0.0, // changeSmokeFrame
        0.0, // explosionFrame
        0.0  // explosionTimer
    ];

    override public function new(?deathSpri:Bool = false)
    {
        super();

        sprigatito = new FlxSprite(496.5,400,'assets/images/sprigatito/sprigFiles/spri_0.png');
        add(sprigatito);
        sweat = new FlxSprite(0,0,'assets/images/sprigatito/suor.png');
        add(sweat);
        pant = new FlxSprite(0,0,'assets/images/sprigatito/fumaca.png');
        add(pant);
        fumaca = new FlxSprite(675, 175, 'assets/images/sprigatito/fumaca/fumaca_0.png');
        add(fumaca);
        explosao = new FlxSprite(426.5,280,'assets/images/sprigatito/explosao/explosao_0.png');
        add(explosao);

        preloadShit();
        if(deathSpri) deathAnim();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        allValuesTimeFrame[3] += 1/100;
        if(allValuesTimeFrame[3] >= 0.25) {
            allValuesTimeFrame[3] = 0;
            allValuesTimeFrame[2]=(allValuesTimeFrame[2]==2)?0:allValuesTimeFrame[2]+1;
            fumaca.loadGraphic('assets/images/sprigatito/fumaca/fumaca_${allValuesTimeFrame[2]}.png');
        }

        if(FlxG.mouse.pressed) {
            allValuesTimeFrame[1] = 1;
            if(fumaca.visible == false) fumaca.visible = true;
        } else {
            allValuesTimeFrame[1] = (PlayState.bothTimer[1] <= 99) ? 2 : 0;
            if(fumaca.visible == true) { fumaca.visible = false;  if(allValuesTimeFrame[1]==2) { pantThing(); dripStuff();} }
        }

        if(allValuesTimeFrame[0] != allValuesTimeFrame[1]) {
            allValuesTimeFrame[0] = allValuesTimeFrame[1];
            sprigatito.loadGraphic('assets/images/sprigatito/sprigFiles/spri_${allValuesTimeFrame[0]}.png');

            FlxTween.cancelTweensOf(sprigatito);
            sprigatito.scale.set(1.25, 1.25);
            
            FlxTween.tween(sprigatito, {"scale.x": 1, "scale.y":1}, 0.75, {ease: FlxEase.expoOut});
        }

        if(sprigatitoDead) {
            if(explosao.alpha == 1)
                allValuesTimeFrame[5] += 1/100;

            if(allValuesTimeFrame[5] >= 0.05) {
                allValuesTimeFrame[5] = 0;
                ++allValuesTimeFrame[4];
                explosao.loadGraphic('assets/images/sprigatito/explosao/explosao_${allValuesTimeFrame[4]}.png');
            }
        }
    }

    public function dripStuff()
    {
        if(allValuesTimeFrame[1] == 2) {
            sweat.setPosition(FlxG.random.int(500, 765), 450); sweat.alpha = 1;

            FlxTween.cancelTweensOf(sweat);
            FlxTween.tween(sweat, {y:550, alpha: 0}, 1.5, {ease: FlxEase.expoIn, onComplete: function(lmao:FlxTween) { dripStuff(); }});
        }
    }

    public function pantThing()
    {
        if(allValuesTimeFrame[1] == 2) {
            pant.setPosition(FlxG.random.int(578, 732), FlxG.random.int(446, 523)); pant.scale.set(1, 1); pant.alpha = 1; pant.angle = 0;

            FlxTween.cancelTweensOf(pant);
            FlxTween.tween(pant, {angle: 50, "scale.x": 0.8, "scale.y": 0.8, alpha: 0}, 1, {ease: FlxEase.sineInOut, onComplete: function(lmao:FlxTween) { pantThing(); }});
        }
    }

    public function deathAnim()
    {
        sprigatitoDead = true;

        sprigatito.visible = false;
        fumaca.visible = false;
        explosao.alpha = 1;

        explosao.scale.set(1.2, 1.2);
        FlxTween.tween(explosao, {"scale.x": 1, "scale.y":1}, 0.15, {ease: FlxEase.expoOut, onComplete: function(a:FlxTween){this.destroy();}});
    }

    public function preloadShit() // preloada imagens e seta elas ao inicial
    {
        for(i in 0...3) {
            sprigatito.loadGraphic('assets/images/sprigatito/sprigFiles/spri_$i.png');
            fumaca.loadGraphic('assets/images/sprigatito/fumaca/fumaca_$i.png');
            explosao.loadGraphic('assets/images/sprigatito/explosao/explosao_$i.png');
        }

        sprigatito.loadGraphic('assets/images/sprigatito/sprigFiles/spri_0.png');
        explosao.loadGraphic('assets/images/sprigatito/explosao/explosao_0.png');
        fumaca.visible = false;
        explosao.alpha = 0;
        pant.alpha = 0;
        sweat.alpha = 0;
        fumaca.alpha = 0.5;

        // feio
        sprigatitoDead = false;

        for(i in 0...allValuesTimeFrame.length)
            allValuesTimeFrame[i] = 0.0;
    }
}