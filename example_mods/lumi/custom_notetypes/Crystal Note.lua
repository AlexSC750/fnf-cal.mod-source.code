function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Crystal Note' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'custom-note-stuff/CRYSTALNOTE_assets');
			setPropertyFromGroup('unspawnNotes', i, 'hitHealth', '0.0115');
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', '0.02375');
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
			end
		end
	end
end