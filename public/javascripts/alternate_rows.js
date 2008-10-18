var AlternateRows = Class.create()
Object.extend(AlternateRows, {
	
  setup: function(element) {
	var i = 0
	for (var j = 0; j < element.rows.length; j++){
		element.rows[j].addClassName(((i % 2) == 0) ? 'odd' : 'even')
		i += 1
	}
  },
  
  setupAll: function() {
    $$('.alternate-rows').each(AlternateRows.setup)
  }
})

Event.observe(document, 'dom:loaded', AlternateRows.setupAll)