function onCreatePost()
    setProperty('camGame.alpha', 0)
end

function onBeatHit()
    if curBeat == 32 then
        doTweenAlpha('hi', "camGame", 1, bpm/30)
    end
end