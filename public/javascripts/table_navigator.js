var TableNavigator = Class.create()

TableNavigator.prototype = {

	initialize:function(tables, div) {
		this.tables = tables
		this.div = $(div)
		this.input = new Element('input', {type: 'search', accesskey:'f', className:'search'})
		this.input.observe('keyup', this.search.bindAsEventListener(this))
		this.div.appendChild(this.input)
		this.buildInitialList()
	},
	
	navigate:function(){
		if (!this.results[0])
			return
		window.location = this.results[0][1]
	},
	
	buildInitialList:function(){
		this.list = document.createElement('ul')
		this.displayList(this.tables)
		this.div.appendChild(this.list)
	},
	
	search:function(e){
		if (e.keyCode == Event.KEY_RETURN)
			return this.navigate()
		if (e.keyCode == Event.KEY_ESC)
			this.input.value = ''
		this.results = this.tables.findAll(function(e){
			return e[0].startsWith(this.input.value)
		}, this)
		this.displayList(this.results)
	},
	
	displayList:function(coll){
		this.list.innerHTML = ''
		var li, a
		for (var i=0; i < coll.length; i++) {
			li = document.createElement('li')
			a = new Element('a', {href:coll[i][0]}).update(coll[i][0])
			li.appendChild(a)
			this.list.appendChild(li)
		}
	}	
}
