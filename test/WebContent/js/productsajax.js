function productsAction(id, actionType) {
	var params = new Array();
	var elements = ["nam", "sku", "category", "price"];
	if (actionType == "insert"){
	for (var i = 0; i < elements.length; i++) {
	    var key = elements[i];
	    var ele = key;
	    var element = document.getElementById(ele);
	    var value = element.value;
	    params.push(key + "=" + value);
	}
	}
	if (actionType == "update"){
		
		for (var i = 0; i < elements.length; i++) {
			
		    var key = elements[i];
		    var ele = key + "_" + id;

		    var element = document.getElementById(ele);
		    var value = element.value;

		    params.push(key + "=" + value);
		}
	}
	if (actionType == "delete" || actionType == "update"){
		params.push("id=" + id);
	}
	params.push("action=" + actionType);
	makeProductsRequest(id, params, actionType);
}

function makeProductsRequest(id, params, actionType){
	var xmlHttp=new XMLHttpRequest();	
	xmlHttp.onreadystatechange=function() {
		if (xmlHttp.readyState != 4) return;
		
		if (xmlHttp.status != 200) {
			alert("HTTP status is " + xmlHttp.status + " instead of 200");
			return;
		};
		var responseDoc = xmlHttp.responseText;
		var response = eval('(' + responseDoc + ')');
		switch (actionType){
		    case "insert":
		        if (response.success) {
		            var table = document.getElementById("productTable");

		            var row = table.insertRow(table.rows.length);
		            row.id = id;
		            document.getElementById("nam").value="";
		            document.getElementById("sku").value="";
		            document.getElementById("price").value="";
		            
		            document.getElementById("alert").innerHTML = "";
		            document.getElementById("alert").innerHTML = "<div class='alert alert-success'><button type='button' class='close' data-dismiss='alert'>&times;</button><h4>Success!</h4>Item has been added!</div>";
		            var html = '<td>' + response.id + '</td><td><input value="' + response.nam + '" name="nam" size="15" /></td><td><input value="'
		                        + response.sku + '" name="sku" size="15" /></td><td><select>' + document.getElementById("category_1").innerHTML
		                        + '</select></td><td><input value="' + response.price + '" name="price" size="15" /></td>'
		            			+ "<td><input id='UP" + response.id + "' onClick=\"productsAction('" + response.id + "', 'update');\" type=\"button\" value=\"Update\"></td>"
		            			+ "<td><input id='DEL" + response.id + "' onClick=\"productsAction('" + response.id + "', 'delete');\" type=\"button\" value=\"Delete\"></td>";
		            row.innerHTML = html;
		            var ele = document.getElementById("UP" + response.id);
		            var ele2 = document.getElementById("DEL" + response.id);
		            ele.onclick = new Function("productsAction('" + response.id + "' , 'update')");
		            ele2.onclick = new Function("productsAction('" + response.id + "' , 'delete')");
		            //ele2.on("click", ".button", function() { productsAction("'" + response.id + "'", 'delete');});
		        }
			break;
			
			case "update":
			    if (response.success) {
			    	document.getElementById("alert").innerHTML = "";
		            document.getElementById("alert").innerHTML = "<div class='alert alert-info'><button type='button' class='close' data-dismiss='alert'>&times;</button><h4>Success!</h4>Product has been updated!</div>";
				}
			break;
			
			case "delete":
			    if (response.success) {
					//document.getElementById('response').innerHTML =  responseDoc.trim();
					var parent = document.getElementById('products');
					var child = document.getElementById("id_" + id);
					document.getElementById("alert").innerHTML = "";
		            document.getElementById("alert").innerHTML = "<div class='alert alert-block'><button type='button' class='close' data-dismiss='alert'>&times;</button><h4>Item deleted!</h4>This action cannot be reversed!</div>";
					parent.removeChild(child);
				}
			break;
		
		}

	};
	
	// Send XHR request
	var url = "ProductInsert.jsp"
	var url="ProductInsert.jsp?" + params.join("&");
	xmlHttp.open("POST",url,true);
	xmlHttp.send(null);
}