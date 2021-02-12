var divJSON; // storing div where JSON code is located
var divXML;
var divYAML;
var divs = document.getElementsByClassName("listingblock");
for (var i = 0; i < divs.length; i++) {
    try {

        var div = divs[i].getElementsByClassName("content");
        var pre = div[0].getElementsByClassName("CodeRay highlight");
        var code = pre[0].getElementsByTagName("code");
        switch (code[0].getAttribute('data-lang')) {
            case "xml":
                divXML = divs[i];
                break;
            case "json":
                divJSON = divs[i];
                break;
            case "yaml":
                divYAML = divs[i];
                break;
        }
        console.log(divJSON);
        if (divXML != null && divJSON != null && divYAML != null) {
            divJSON.style.display = 'none';
            divXML.style.display = 'none';
            divYAML.style.display = 'none';
            console.log("hidden");
            showMenu();
        } else {
            var altdiv = $(divs[i]).next();
            var altdiv2 = altdiv[0].getElementsByClassName("content");
            var preAlt = altdiv2[0].getElementsByClassName("CodeRay highlight");
            var codeAlt = preAlt[0].getElementsByTagName("code");
            var atr = codeAlt[0].getAttribute('data-lang');
            if (atr != "xml" && atr != "json" && atr != "yaml") {
                throw new Error("next element is not code!" + parAlt[0].getAttribute());
            }
        }

    } catch (e) {
        console.log(e.message);
        divJSON = null;
        divXML = null;
        divYAML = null;
    }

}

function showMenu() {
    var dJSON = divJSON;
    var dXML = divXML;
    var dYAML = divYAML;
    var myDiv = document.createElement("div");
    myDiv.className = "multilistingblock";
    var parent = divXML.parentNode;
    parent.insertBefore(myDiv, divJSON);
    divJSON = null;
    divXML = null;
    divYAML = null;
    var myUl = document.createElement("ul");
    myUl.className = "nav nav-tabs";
    myDiv.appendChild(myUl);
    var firstLi = document.createElement("li");
    firstLi.className = "nav-item";
    myUl.appendChild(firstLi);
    var firstA = document.createElement("a");
    firstA.className = "nav-link active";
    firstA.innerText = "XML";
    firstLi.appendChild(firstA);
    var secondLi = document.createElement("li");
    secondLi.className = "nav-item";
    myUl.appendChild(secondLi);
    var secondA = document.createElement("a");
    secondA.className = "nav-link";
    secondA.innerText = "JSON";
    secondLi.appendChild(secondA);
    var thirdLi = document.createElement("li");
    thirdLi.className = "nav-item";
    myUl.appendChild(thirdLi);
    var thirdA = document.createElement("a");
    thirdA.className = "nav-link";
    thirdA.innerText = "YAML";
    thirdLi.appendChild(thirdA);
    var codeDiv = document.createElement("div");
    codeDiv.innerHTML = dXML.innerHTML;
    myDiv.appendChild(codeDiv);

    firstA.addEventListener('click', function() {
        secondA.className = "nav-link";
        thirdA.className = "nav-link";
        firstA.className = "nav-link active";
        codeDiv.innerHTML = dXML.innerHTML;
    });

    secondA.addEventListener('click', function() {
        thirdA.className = "nav-link";
        firstA.className = "nav-link";
        activeLink = 1;
        secondA.className = "nav-link active";
        codeDiv.innerHTML = dJSON.innerHTML;
    });

    thirdA.addEventListener('click', function() {
        firstA.className = "nav-link";
        secondA.className = "nav-link";
        thirdA.className = "nav-link active";
        codeDiv.innerHTML = dYAML.innerHTML;
    });

}