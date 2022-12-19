drain = false

function onEvent(name, value1, value2)
    if name == "" then
        drain = not drain
    end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    if drain then
        if (getProperty('health') - 0.015) > 0 then
            setProperty('health', getProperty('health') - 0.015)
        end
    end
end