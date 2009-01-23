function parentRow(elt){
	while (elt.tagName != 'TR')
		elt = elt.parentNode
	return elt
}