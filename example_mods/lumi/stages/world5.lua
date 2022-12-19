function onCreate()
    makeLuaSprite('bg', 'mod-bgs/world5/bg', -1200, -500)
    makeLuaSprite('floor', 'mod-bgs/world5/floor', -1200, -500)
    makeLuaSprite('speakers', 'mod-bgs/world5/speaker', -1340, -590)
    makeAnimatedLuaSprite('hexa1', 'mod-bgs/world5/hexagonSS', 82, 644) --80 less on X, 90 less on Y
    makeAnimatedLuaSprite('hexa2', 'mod-bgs/world5/hexagonSS', 314, 610)
    makeAnimatedLuaSprite('hexa3', 'mod-bgs/world5/hexagonSS', 314, 395)
    makeAnimatedLuaSprite('hexa4', 'mod-bgs/world5/hexagonSS', 615, 644)
    addAnimationByPrefix('hexa1', 'boop', 'boop', curBpm/2, false)
    addAnimationByPrefix('hexa2', 'boop', 'boop', curBpm/2, false)
    addAnimationByPrefix('hexa3', 'boop', 'boop', curBpm/2, false)
    addAnimationByPrefix('hexa4', 'boop', 'boop', curBpm/2, false)
    scaleObject('bg', 1.25, 1.25)
    scaleObject('floor', 1.25, 1.25)
    scaleObject('speakers', 1.35, 1.35)
    scaleObject('hexa1', 1.35, 1.35)
    scaleObject('hexa2', 1.65, 1.65)
    scaleObject('hexa3', 1.65, 1.65)
    scaleObject('hexa4', 1.35, 1.35)
    addLuaSprite('bg')
    addLuaSprite('floor')
    addLuaSprite('speakers')
    addLuaSprite('hexa1')
    addLuaSprite('hexa2')
    addLuaSprite('hexa3')
    addLuaSprite('hexa4')
end

function onCountdownTick(counter)
    if counter == 4 then
        objectPlayAnimation('hexa1', 'boop', true)
        objectPlayAnimation('hexa2', 'boop', true)
        objectPlayAnimation('hexa3', 'boop', true)
        objectPlayAnimation('hexa4', 'boop', true)
    end
end

function onBeatHit()
    objectPlayAnimation('hexa1', 'boop', true)
    objectPlayAnimation('hexa2', 'boop', true)
    objectPlayAnimation('hexa3', 'boop', true)
    objectPlayAnimation('hexa4', 'boop', true)
end
