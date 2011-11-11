function MyAppGetHTMLElementsAtPoint(x,y){
var tags = ",";
	var e = document.elementFromPoint(x,y);
	while (e) {
		if(e.tagName){
			tags += e.tagName + ',';
		}
		e = e.parentNode;
	
	}
	
	return tags;
}


function MyAppGetHTMLLinkAtPoint(x,y){
    var tags = ",";
    var src = null;
    var link = null;
	var e = document.elementFromPoint(x,y);
	while (e) {
        if (e.tagName){
//            alert(e.tagName);            
			tags += e.tagName + ',';
        }
		if (link == null && e.tagName && e.tagName.toLowerCase() == "a"){
//            alert("It's A");
            link = e.href;
//            alert(link);
		}
        else if (src == null && e.tagName && e.tagName.toLowerCase() == "img"){
            src = e.src;
//            alert(src);
        }
        else if (link == null && e.tagName && e.tagName.toLowerCase() == "embed"){
            link = e.getAttribute("href");
//            alert(link);
        }
        else if (link == null && e.tagName && e.tagName.toLowerCase() == "video"){
            link = e.getAttribute("src");
//            alert(link);
        }
		e = e.parentNode;        
	}
	
    var sep = "$$_$$";
    var str = "";
    
    if (link != null)
        str = str + link + sep;
    else
        str = str + sep;
    
    if (src != null)
        str = str + src + sep;
    else
        str = str + sep;
    
    str = str + tags;

    return str;
}