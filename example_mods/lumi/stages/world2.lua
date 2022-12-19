function onCreate()
    makeLuaSprite('bg', 'mod-bgs/world2/bg', -1200, -500)
    makeLuaSprite('floor', 'mod-bgs/world2/floor', -1200, -500)
    makeLuaSprite('speakers', 'mod-bgs/world2/speakers', -1340, -590)
    makeAnimatedLuaSprite('beat1', 'mod-bgs/world2/squareAnim', 162, 734)
    makeAnimatedLuaSprite('beat2', 'mod-bgs/world2/squareAnim', 394, 691)
    makeAnimatedLuaSprite('beat3', 'mod-bgs/world2/squareAnim', 390, 485)
    makeAnimatedLuaSprite('beat4', 'mod-bgs/world2/squareAnim', 675, 700)
    makeLuaSprite('gas stuff', 'mod-bgs/world2/gas-thing', -1210, -500)
    addAnimationByPrefix('beat1', 'boop', 'boop', curBpm/2, false)
    addAnimationByPrefix('beat2', 'boop', 'boop', curBpm/2, false)
    addAnimationByPrefix('beat3', 'boop', 'boop', curBpm/2, false)
    addAnimationByPrefix('beat4', 'boop', 'boop', curBpm/2, false)
    scaleObject('bg', 1.25, 1.25)
    scaleObject('floor', 1.25, 1.25)
    scaleObject('speakers', 1.35, 1.35)
    scaleObject('beat1', 1.25, 1.25)
    scaleObject('beat2', 1.65, 1.65)
    scaleObject('beat3', 1.65, 1.65)
    scaleObject('beat4', 1.55, 1.55)
    scaleObject('gas stuff', 1.25, 1.25)
    addLuaSprite('bg')
    addLuaSprite('floor')
    addLuaSprite('speakers')
    addLuaSprite('beat1')
    addLuaSprite('beat2')
    addLuaSprite('beat3')
    addLuaSprite('beat4')
    addLuaSprite('gas stuff')
    setObjectOrder('gas stuff', 10)
end

function onCountdownTick(counter)
    if counter == 4 then
        objectPlayAnimation('beat1', 'boop', true)
        objectPlayAnimation('beat2', 'boop', true)
        objectPlayAnimation('beat3', 'boop', true)
        objectPlayAnimation('beat4', 'boop', true)
    end
end

function onBeatHit()
    objectPlayAnimation('beat1', 'boop', true)
    objectPlayAnimation('beat2', 'boop', true)
    objectPlayAnimation('beat3', 'boop', true)
    objectPlayAnimation('beat4', 'boop', true)
end

function onEvent(name, value1, value2)
    if name == "" then
        doTweenAlpha('bye', "camGame", value1, curBpm/60)
        doTweenAlpha('bye2', "camHUD", value2, curBpm/60)
    end
end