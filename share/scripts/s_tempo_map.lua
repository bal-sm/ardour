ardour { ["type"] = "Snippet", name = "tempo map examples" }

function factory () return function ()

	-- query BPM at 00:00:10:00
	local tp = Temporal.timepos_t (Session:nominal_sample_rate () * 10)
	local tm = Temporal.TempoMap.read ()
	print (tm:quarters_per_minute_at (tp))
	tm = nil

	-- set initial tempo to 140, ramp to 120 over the first 4/4 bar, then continue at BPM 80
	local tm = Temporal.TempoMap.write_copy ()
	tm:set_tempo (Temporal.Tempo (140, 120, 4), Temporal.timepos_t (0))
	tm:set_tempo (Temporal.Tempo (120, 80, 4), Temporal.timepos_t.from_ticks (Temporal.ticks_per_beat * 4))
	tm:set_tempo (Temporal.Tempo (80, 80, 4), Temporal.timepos_t.from_ticks (Temporal.ticks_per_beat * 4))
	Session:begin_reversible_command ("Change Tempo Map")
	Temporal.TempoMap.update (tm)
	if not Session:abort_empty_reversible_command () then
		Session:commit_reversible_command (nil)
	end
	tm = nil

	-- Abort Edit example
	-- after every call to Temporal.TempoMap.write_copy ()
	-- there must be a matching call to
	-- Temporal.TempoMap.update() or Temporal.TempoMap.abort_update()
	Temporal.TempoMap.write_copy()
	Temporal.TempoMap.abort_update()

end end
