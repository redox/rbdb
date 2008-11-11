var TableNavigator = Class.create()

TableNavigator.prototype = {

	initialize:function(tables, div) {
		this.tables = tables
		this.div = $(div)
		this.input = new Element('input', {type: 'search', accesskey:'f', className:'search', title: 'Access key: f'})
		this.input.observe('keyup', this.search.bindAsEventListener(this))
		this.div.appendChild(this.input)
		this.buildInitialList()
	},
	
	navigate:function(){
		if (!this.results[this.selectedResult])
			return
		window.location = this.results[this.selectedResult][1]
	},
	
	buildInitialList:function(){
		this.list = document.createElement('ul')
		this.displayList(this.tables)
		this.div.appendChild(this.list)
	},
	
	search:function(e){
		if (e.keyCode == Event.KEY_RETURN)
			return this.navigate()
		if (e.keyCode == Event.KEY_UP || e.keyCode == Event.KEY_DOWN)
			return this.move(e.keyCode)
		if (e.keyCode == Event.KEY_ESC)
			this.input.value = ''
		this.results = this.tables.findAll(function(e){
			return e[0].toLowerCase().startsWith(this.input.value.toLowerCase())
		}, this)
		this.displayList(this.results)
		this.select(0)
	},
	
	move:function(keyCode){
		if (this.selectedResult == null)
			return this.select(0)
		if (keyCode == Event.KEY_UP)
			if (this.selectedResult == 0)
				this.select(this.results.length - 1)
			else
				this.select(this.selectedResult - 1)
		else
			if (this.selectedResult == (this.results.length - 1))
				this.select(0)
			else
				this.select(this.selectedResult + 1)
	},
	
	displayList:function(coll){
		this.list.innerHTML = ''
		var li, a
		for (var i=0; i < coll.length; i++) {
			li = document.createElement('li')
			a = new Element('a', {href:coll[i][1]}).update(coll[i][0])
			li.appendChild(a)
			this.list.appendChild(li)
		}
	},
	
	select:function(index){
		if (this.selectedResult != null)
			Element.removeClassName(this.list.childNodes[this.selectedResult], 'selected')
		this.selectedResult = index
		Element.addClassName(this.list.childNodes[index], 'selected')
	}
}
