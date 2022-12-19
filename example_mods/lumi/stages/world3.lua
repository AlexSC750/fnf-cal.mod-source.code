math.randomseed(os.time())
preCDtweencheck = false
tweening = false
tweenAngle1 = math.random(-180, 180)
tweenAngle2 = math.random(-180, 180)
tweenAngle3 = math.random(-180, 180)
tweenAngle4 = math.random(-180, 180)

function onCreate()
    makeLuaSprite('bg', 'mod-bgs/world3/bg', -1200, -500)
    makeLuaSprite('floor', 'mod-bgs/world3/floor', -1200, -500)
    makeLuaSprite('speakers', 'mod-bgs/world3/speaker', -1340, -590)
    makeLuaSprite('eye1', 'mod-bgs/world3/eye', 182, 756)
    makeLuaSprite('eye2', 'mod-bgs/world3/eye', 421, 715)
    makeLuaSprite('eye3', 'mod-bgs/world3/eye', 418, 510)
    makeLuaSprite('eye4', 'mod-bgs/world3/eye', 695, 728)
    scaleObject('bg', 1.25, 1.25)
    scaleObject('floor', 1.25, 1.25)
    scaleObject('speakers', 1.35, 1.35)
    scaleObject('eye1', 1.25, 1.25)
    scaleObject('eye2', 1.65, 1.65)
    scaleObject('eye3', 1.65, 1.65)
    scaleObject('eye4', 1.55, 1.55)
    addLuaSprite('bg')
    addLuaSprite('floor')
    addLuaSprite('speakers')
    addLuaSprite('eye1')
    addLuaSprite('eye2')
    addLuaSprite('eye3')
    addLuaSprite('eye4')
    spinEyes(false)
end

function onUpdate(elapsed)
    if tweening == true then
        spinEyes(true)
    end
end

function onBeatHit()
    if curBeat % 2 == 0 then
        tweening = true
        randomizeAngle()
    end
end

function onCountdownTick(counter)
    if counter == 4 then
        tweening = true
        randomizeAngle()
    end
end

function onTweenCompleted(tag)
    if tag == 'spin1' then
        tweening = false
    end
end

function randomizeAngle()
    tweenAngle1 = math.random(-180, 180)
    tweenAngle2 = math.random(-180, 180)
    tweenAngle3 = math.random(-180, 180)
    tweenAngle4 = math.random(-180, 180)
end

function spinEyes(callTweenConpletion)
    if callTweenConpletion then
        doTweenAngle('spin1', 'eye1', tweenAngle1, 0.1)
        doTweenAngle('spin2', 'eye2', tweenAngle2, 0.1)
        doTweenAngle('spin3', 'eye3', tweenAngle3, 0.1)
        doTweenAngle('spin4', 'eye4', tweenAngle4, 0.1)
    else
        doTweenAngle('prespin1', 'eye1', tweenAngle1, 0.1)
        doTweenAngle('prespin2', 'eye2', tweenAngle2, 0.1)
        doTweenAngle('prespin3', 'eye3', tweenAngle3, 0.1)
        doTweenAngle('prespin4', 'eye4', tweenAngle4, 0.1)
    end
end