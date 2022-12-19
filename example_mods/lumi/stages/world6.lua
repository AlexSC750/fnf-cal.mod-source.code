tweening = false
bit = 1

function onCreate()
    makeLuaSprite('bg', 'mod-bgs/world6/bg', -1200, -500)
    makeLuaSprite('floor', 'mod-bgs/world6/actual-floor-jesus', -1200, -500)
    makeLuaSprite('lava', 'mod-bgs/world6/this-is-lava-i-swear', -1200, -500)
    makeLuaSprite('tri', 'mod-bgs/world6/triangle', -1200, -200)
    makeLuaSprite('speakers', 'mod-bgs/world6/speaker', -1340, -590)
    makeLuaSprite('gear1', 'mod-bgs/world6/gear', 162, 714)
    makeLuaSprite('gear2', 'mod-bgs/world6/gear', 414, 670)
    makeLuaSprite('gear3', 'mod-bgs/world6/gear', 414, 515)
    makeLuaSprite('gear4', 'mod-bgs/world6/gear', 700, 714)
    scaleObject('bg', 1.25, 1.25)
    scaleObject('floor', 1.25, 1.25)
    scaleObject('speakers', 1.35, 1.35)
    scaleObject('gear1', 1.35, 1.35)
    scaleObject('gear2', 1.65, 1.65)
    scaleObject('gear3', 1.65, 1.65)
    scaleObject('gear4', 1.35, 1.35)
    scaleObject('lava', 1.25, 1.25)
    scaleObject('tri', 1.25, 1)
    addLuaSprite('bg')
    addLuaSprite('lava')
    addLuaSprite('speakers')
    addLuaSprite('tri')
    addLuaSprite('floor')
    addLuaSprite('gear1')
    addLuaSprite('gear2')
    addLuaSprite('gear3')
    addLuaSprite('gear4')
    doTweenAngle('snap', 'gear2', 22.5, 0.01)
    addGlitchEffect('lava', 2, 2, 0.03)
end

function onUpdate()
    if tweening == true then
        spin()
    end
end

function onBeatHit()
    if curBeat % 2 == 0 then
        doTweenAngle('snap1', 'gear1', 0, 0.01)
        doTweenAngle('snap2', 'gear2', 22.5, 0.01)
        doTweenAngle('snap3', 'gear3', 0, 0.01)
        doTweenAngle('snap4', 'gear4', 0, 0.01)
        tweening = true
    end
end

function onCountdownTick(counter)
    if counter == 4 then
        tweening = true
    end
end

function spin()
    doTweenAngle('spin1', 'gear1', 360, 0.2)
    doTweenAngle('spin2', 'gear2', -337.5, 0.2)
    doTweenAngle('spin3', 'gear3', 360, 0.2)
    doTweenAngle('spin4', 'gear4', 360, 0.2)
end

function onTweenCompleted(tag)
    if tag == 'spin1' then
        tweening = false
    end
end