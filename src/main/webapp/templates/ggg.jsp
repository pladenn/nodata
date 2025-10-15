<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">

    <style>

        :root {
            --wd: 270px;
            --mr: 10px;
            --amr: 4px;
            --apl: 6px;
            --lf: 280px;
        }

        .darrow {
            font-size: 11pt;
            position: absolute;
            top: 5px;
            right: 4px;
        }

        .rarrow {
            font-size: 13pt;
            position: absolute;
            top: 0px;
            right: 4px;
        }

        ul#navmenu li {
            width: var(--wd);
            text-align: left;
            position: relative;
            float: left;
            margin-right: var(--mr);
            color: black;
            background-color: white;
        }


        ul#navmenu li[class="msub"] {
            color: white;
        }

        ul#navmenu li[class="msub"] > a {
            background-color: #04AA6D;
            color: white;
        }

        ul#navmenu a {
            text-decoration: none;
            display: block;
            width: var(--wd);
            height: 25px;
            line-height: 25px;
            margin-left: var(--amr);
            padding-left: var(--apl);
            color: black;
        }

        ul#navmenu li:hover {
            color: white;
        }

        ul#navmenu a:hover {
            text-decoration: none;
            display: block;
            width: var(--wd);
            height: 25px;
            line-height: 25px;
        }

        ul#navmenu li:hover > a {
            background-color: #04AA6D;
            color: white;
        }

        ul#navmenu li:hover a:hover {
            background-color: #04AA6D;
            color: white;

        }

        ul#navmenu, ul[class^="sub"] {
            padding: 0px;
            list-style-type: none;
            /*font-size: 9pt;*/
            font-family: arial, sans-serif;
        }

        ul#navmenu ul[class^="sub"] {
            display: none;
            position: absolute;
            top: 0px;
            left: var(--lf);
        }

        ul#navmenu ul[class^="sub"] a {
            margin-left: var(--amr);
            padding-left: var(--apl);
        }

        ul#navmenu ul.sub1 {
            top: 25px;
            left: 0px;
        }

        ul#navmenu .sub1 a {
            /*margin-top: 5px;*/
        }

        ul#navmenu li:hover .sub1 {
            display: block;
        }

        ul#navmenu .sub1 li:hover .sub2 {
            display: block;
        }

        ul#navmenu .sub1 li:hover .sub2 li:hover .sub3 {
            display: block;
        }

        ul#navmenu .sub1 li:hover .sub2 li:hover .sub3 li:hover .sub4 {
            display: block;
        }

        ul#navmenu .sub1 li:hover .sub2 li:hover .sub3 li:hover .sub4 li:hover .sub5 {
            display: block;
        }

        ul#navmenu .sub1 li:hover .sub2 li:hover .sub3 li:hover .sub4 li:hover .sub5 li:hover.sub5 {
            display: block;
        }

        ul#navmenu .sub1 li:hover .sub2 li:hover .sub3 li:hover .sub4 li:hover .sub5 li:hover .sub6 li:hover.sub5 {
            display: block;
        }

        ul#navmenu .sub1 li:hover .sub2 li:hover .sub3 li:hover .sub4 li:hover .sub5 li:hover .sub6 li:hover .sub7 li:hover.sub5 {
            display: block;
        }

    </style>

    <style>
        table {
            font-family: arial, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        td, th {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }

/*        tr:nth-child(even) {
            background-color: #dddddd;
        }*/

        .dropbtn {
            background-color: #04AA6D;
            color: white;
            padding: 8px;
            border: none;
            cursor: pointer;
        }

        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-content {
            width: fit-content;
            display: none;
            position: absolute;
            right: 0;
            background-color: #f9f9f9;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
            z-index: 1;
        }

        .dropdown-content a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
        }

        .dropdown-content a:hover {
            background-color: #f1f1f1;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .dropdown:hover .dropbtn {
            background-color: #3e8e41;
        }

        /* Style the tab */
        .tab {
            overflow: hidden;
            border: 1px solid #ccc;
            background-color: #f1f1f1;
        }

        /* Style the buttons inside the tab */
        .tab button {
            background-color: inherit;
            float: left;
            border: none;
            outline: none;
            cursor: pointer;
            padding: 14px 16px;
            transition: 0.3s;
            font-size: 17px;
        }

        /* Change background color of buttons on hover */
        .tab button:hover {
            background-color: #ddd;
        }

        /* Create an active/current tablink class */
        .tab button.active {
            background-color: #ccc;
        }

        /* Style the tab content */
        .tabcontent {
            display: none;
            padding: 6px 12px;
            border: 1px solid #ccc;
            border-top: none;
        }

        input[type=text], select, textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            margin-top: 6px;
            margin-bottom: 16px;
            resize: vertical;
        }

        input[type=submit] {
            background-color: #04AA6D;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        input[type=submit]:hover {
            background-color: #45a049;
        }

        .container {
            border-radius: 5px;
            background-color: #f2f2f2;
            padding: 20px;
        }

        .select-editable {
            position: relative;
            background-color: white;
            border: solid grey 1px;
            width: 100%;
            height: 42px;
        }

        .select-editable select {
            position: absolute;
            top: 0px;
            left: 0px;
            font-size: 14px;
            border: none;
            width: 100%;
            margin: 0;
        }

        .select-editable input {
            position: absolute;
            top: 0px;
            left: 0px;
            width: 300px;
            padding: 12px;
            font-size: 12px;
            border: none;
            margin: 0;
        }

        .select-editable select:focus, .select-editable input:focus {
            outline: none;
        }
    </style>
</head>

<div>
    <a id="_original_url">Back</a>
</div>

<div style="height: 50px;">
    <ul id="navmenu"></ul>
</div>

<div style="border: 1px solid #ccc; padding: 10px;">
    <h2 id="action_title"></h2>
</div>

<div class="tab">
    <button class="tablinks" onclick="openTab(event, 'data')">Data</button>
    <button class="tablinks" onclick="openTab(event, 'parameters')">Parameters</button>
</div>

<div id="data" class="tabcontent">
    <div class="dropdown" style="float: left; padding: 10px;">
        <button id="action_shared_actions" class="dropbtn">Actions</button>
        <button id="copy_source_data">Copy source data</button>
        <button id="copy_script">Copy script</button>
    </div>
    <table id="data_table" style="table-layout:auto">
    </table>
</div>

<div id="parameters" class="tabcontent">
    <button id="apply">Apply</button>
</div>

<script>
    let navmenu = document.getElementById("navmenu");

    function createMenuItemLink(item) {
        let link = document.createElement("a");
        link.innerText = item.name;

        if (item.link != null) {
            link.href = item.link;
        }

        return link;
    }

    function createDownArrow() {
        let arrow = document.createElement("span");
        arrow.innerText = "▼";
        arrow.classList.add("darrow");
        return arrow;
    }

    function createRightArrow() {
        let arrow = document.createElement("span");
        arrow.innerText = "▶";
        arrow.classList.add("rarrow");
        return arrow;
    }

    function createSubMenu(items, level) {
        let subMenu = document.createElement("ul");
        subMenu.classList.add("sub" + level);

        for (let item of items) {
            subMenu.append(createMenuItem(item, level + 1));
        }

        return subMenu;
    }

    function createMenuItem(item, level) {
        let menuItem = document.createElement("li");
        menuItem.append(createMenuItemLink(item));

        if (level === 1) {
            menuItem.classList.add("msub");
        }

        if (item.items != null) {
            if (level === 1) {
                menuItem.append(createDownArrow(item));
            }
            else {
                menuItem.append(createRightArrow(item));
            }

            if (level <= 7) {
                menuItem.append(createSubMenu(item.items, level))
            }
        }

        return menuItem;
    }

    function createMainMenu(menu) {
        if (menu == null) {
            return;
        }

        for (let item of menu) {
            navmenu.append(createMenuItem(item, 1));
        }
    }

</script>

<script>

    function toActionURL(url) {

        let re = new RegExp("/content/.*/.*/parameters");
        if (!re.test(url.pathname)) {
            return url;
        }

        var pathArray = url.pathname.split('/').slice(0, -1);

        var newPathname = "";
        for (i = 1; i < pathArray.length; i++) {
            newPathname += "/";
            newPathname += pathArray[i];
        }
        return new URL(url.protocol + "//" + url.host + newPathname);

    }

    function applyButtonAction(parameters) {
        let redirectUrl = new URL(window.location.origin);
        redirectUrl.pathname = window.location.pathname;
        redirectUrl = toActionURL(redirectUrl);

        for (let parameter of parameters) {
            var field = document.getElementById(parameter.id);

            if (field.type === "checkbox") {
                redirectUrl.searchParams.append(parameter.name, field.checked);
            } else if (toNullValue(field.value) != null) {
                redirectUrl.searchParams.append(parameter.name, field.value);
            }
        }

        addOriginalUrl(redirectUrl.searchParams, mainData.originalUrl, mainData.originalTitle);

        window.location.href = redirectUrl.href;
    }

    function getApplyButtonAction(parameters) {
        return function () {
            applyButtonAction(parameters);
        }
    }

    function createEditableSelect(parameter) {
        /*
<div class="select-editable">
  <select onchange="this.nextElementSibling.value=this.value">
    <option value=""></option>
    <option value="115x175 mm">115x175 mm</option>
    <option value="120x160 mm">120x160 mm</option>
    <option value="120x287 mm">120x287 mm</option>
  </select>
  <input type="text" name="format" value=""/>
</div>
        * */

        let div = document.createElement("div");
        div.className += "select-editable";

        let select = document.createElement("select");
        div.append(select);
        select.onchange = function() {
            this.nextElementSibling.value=this.value;
        };

        let input = document.createElement("input");
        div.append(input);
        input.type = "text"
        input.id = parameter.id;
        input.value = parameter.value;

        for (let pair of parameter.availableValues) {
            let option = document.createElement("option");
            option.value = pair.value;
            option.selected = pair.value === parameter.value;
            option.innerText = pair.key;
            select.add(option);
        }

        return div;
    }

    function fromNullValue(value) {
        if (value == null) {
            return 'null';
        }
        else if (value === "null") {
            return "'null'"
        }

        return value;
    }

    function toNullValue(value) {
        if (value === 'null') {
            return null;
        }
        else if (value === "'null'") {
            return 'null';
        }

        return value;
    }

    function setParameters(parameters) {
        //<input type="text" placeholder="Your name.." value="yyyy">
        var paramDiv = document.getElementById("parameters");
        var button = document.getElementById("apply");
        for (let parameter of parameters) {
            label = document.createElement("Label");
            label.setAttribute("for", parameter.id);

            if (parameter.title != null && parameter.title.trim() != '') {
                label.innerHTML = parameter.title + '(' + parameter.name + ')';
            }
            else {
                label.innerHTML = parameter.name;
            }

            let parameterValue = fromNullValue(parameter.value);

            if (parameter.availableValues != null && parameter.editableDictionary) {
                paramDiv.insertBefore(label, button);
                paramDiv.insertBefore(createEditableSelect(parameter), button);
            } else if (parameter.availableValues != null) {
                paramDiv.insertBefore(label, button);
                input = document.createElement("select");
                input.id = parameter.id;

                for (let pair of parameter.availableValues) {
                    let option = document.createElement("option");
                    option.value = pair.value;
                    option.selected = pair.value === parameter.value;
                    option.innerText = pair.key;
                    input.add(option);
                }
                paramDiv.insertBefore(input, button);
            } else if (parameter.type === "TEXT") {
                paramDiv.insertBefore(label, button);
                input = document.createElement("textarea");
                input.id = parameter.id;
                input.value = parameterValue;
                input.rows = 20;
                input.cols = 300;
                input.disabled = !parameter.editable;
                paramDiv.insertBefore(input, button);
            } else if (parameter.type === "BOOLEAN") {
                input = document.createElement("input");
                input.type = "checkbox";
                input.id = parameter.id;
                input.value = "true";
                input.checked = parameterValue === "true";
                input.disabled = !parameter.editable;
                paramDiv.insertBefore(input, button);
                paramDiv.insertBefore(label, button);
                paramDiv.insertBefore(document.createElement("br"), button);
            } else {
                paramDiv.insertBefore(label, button);
                input = document.createElement("input");
                input.id = parameter.id;
                input.type = "text";
                input.value = parameterValue;
                input.disabled = !parameter.editable;
                paramDiv.insertBefore(input, button);
            }
        }
        button.onclick = getApplyButtonAction(parameters);
    }

    function setCopyButtons(columns, data, script) {
        var dataButton = document.getElementById("copy_source_data");
        var scriptButton = document.getElementById("copy_script");

        dataButton.onclick = function () {
            navigator.clipboard.writeText(JSON.stringify({columns: columns, data: data}));
        };

        scriptButton.onclick = function () {
            if (script == null) {
                navigator.clipboard.writeText('');
                return;
            }
            navigator.clipboard.writeText(script);
        };
    }

    function openTab(evt, tab) {
        var i, tabcontent, tablinks;
        tabcontent = document.getElementsByClassName("tabcontent");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }
        tablinks = document.getElementsByClassName("tablinks");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        document.getElementById(tab).style.display = "block";
        if (evt != null) {
            evt.currentTarget.className += " active";
        }
    }

    function setColumns(columns, links) {
        if (columns.length === 0) {
            return;
        }

        let tr = document.createElement("tr");
        let table = document.getElementById("data_table")
        table.insertBefore(tr, table.firstChild);

        if (links.length !== 0) {
            tr.appendChild(document.createElement("th"));
        }
        tr.appendChild(document.createElement("th"));
        for (let column of columns) {
            let th = document.createElement("th");
            th.innerText = column.name;
            tr.appendChild(th);
        }
    }

    function setData(columns, links, data) {
        if (data.length === 0) {
            return;
        }
        let table = document.getElementById("data_table")
        let ind = 0;
        for (let line of data) {
            let tr = document.createElement("tr");

            ind++;
            if (ind % 2 === 1) {
                tr.style.backgroundColor = "#dddddd";
            }

            table.appendChild(tr);

            if (links.length !== 0) {
                let td = document.createElement("td");
                tr.appendChild(td);

                let div = document.createElement("div");
                div.classList.add("dropdown");
                div.style.float = "left";
                td.appendChild(div);

                let button = document.createElement("button");
                button.classList.add("dropbtn");
                button.innerHTML = "Actions";
                button.onmouseover = createLinks(links, line, mainData);
                div.appendChild(button);
            }

            let collapse = document.createElement("td");
            tr.appendChild(collapse);
            let btn = document.createElement("button");
            btn.innerHTML = "...";
            collapse.appendChild(btn);
            tr.append(collapse);

            for (let column of columns) {
                let td = document.createElement("td");
                td.innerHTML = eval("line" + "." + column.path);
                tr.appendChild(td);
            }

            let tr1 = document.createElement("tr");
            table.appendChild(tr1);

            let cols = columns.length + 1
            if (links.length !== 0) {
                cols = cols + 1;
            }

            let td = document.createElement("td");
            tr1.append(td);

            td.colSpan = cols;

            let txt = document.createElement("textarea");
            txt.textContent = JSON.stringify(line, null, 4);
            txt.style.resize = "none";
            txt.readOnly = true;
            td.append(txt);
            table.appendChild(tr1);
            tr1.style.display = "none";

            btn.onclick = function () {
                if (tr1.style.display === "contents") {
                    tr1.style.display = "none";
                }
                else {
                    tr1.style.display = "contents";
                }

                txt.style.height = txt.scrollHeight + "px";
                txt.style.overflowY = "hidden";
            };

        }


    }

    function createLinks(links, row, fullData) {
        let created = false

        return function (event) {
            if (created || links.length === 0) {
                return;
            }

            let div = event.currentTarget.parentElement;
            let divLinks = document.createElement("div");
            divLinks.classList.add("dropdown-content");
            divLinks.style.left = "0";
            div.appendChild(divLinks);

            for (let link of links) {
                let lnk = document.createElement("a");
                divLinks.appendChild(lnk);
                lnk.innerHTML = link.title;

                const redirectUrl = new URL(window.location.origin);
                redirectUrl.pathname = link.path;

                for (let ind in link.mapping) {
                    let mp = link.mapping[ind];
                    let path = mp.path;
                    let val = mp.defaultValue;

                    if (path != null && path.startsWith('#')) {
                        val = eval(path.replace('#', 'fullData'));
                    }
                    else if(path != null && row != null) {
                        val = eval("row['" + path + "']");
                    }

                    if (val != null) {
                        redirectUrl.searchParams.append(mp.parameterName, val);
                    }
                }

                addOriginalUrl(redirectUrl.searchParams, window.location.href, mainData.description);

                lnk.href = redirectUrl.href;
            }
            created = true;
        }
    }

    function addOriginalUrl(searchParams, url, title) {
        if (url == null) {
            return;
        }

        let val = new URL(url);
        val.searchParams.delete('_original_url');
        val.searchParams.delete('_original_title');

        searchParams.set('_original_url', val);
        searchParams.set('_original_title', title);
    }

    function setOriginalUrl(originalUrl, originalTitle) {
        let back = document.getElementById('_original_url');

        if (originalUrl == null) {
            back.remove();
            return;
        }

        back.setAttribute("href", originalUrl);

        if (originalTitle == null) {
            back.innerText = 'Back';
        }
        else {
            back.innerText = 'Back to: ' + originalTitle;
        }
    }

    function setActionTitle() {
        document.getElementById('action_title').innerText = mainData.description;
    }

    function setActionTargetButton(actionTarget, fullData) {
        let button = document.getElementById('action_shared_actions');
        button.onmouseover = createLinks(actionTarget, null, fullData);
    }

    function isNotBlank(val) {
        return !(val == null || val.trim() == '');
    }

    var mainData = ${mainData};

    if (isNotBlank(mainData.redirect)){
        window.location.replace(mainData.redirect);
    }
    setOriginalUrl(mainData.originalUrl, mainData.originalTitle);
    createMainMenu(mainData.menuItems);
    setActionTitle();
    setParameters(mainData.parameters);

    let _columns = mainData.columns;
    let _data = mainData.data;

    setCopyButtons(mainData.columns, mainData.data, mainData.postProcess);
    if (mainData.postProcess != null) {
        eval(mainData.postProcess);
    }

    let actionTarget = [];
    let rowTarget = [];
    for (var lnk of mainData.actionLinks) {
        if (lnk.actionTarget) {
            actionTarget.push(lnk);
        } else {
            rowTarget.push(lnk);
        }
    }

    setActionTargetButton(actionTarget, mainData);

    setColumns(_columns, rowTarget);
    if (!Array.isArray(_data)) {
        _data = [_data];
    }

    setData(_columns, rowTarget, _data);
    openTab(event, mainData.tab.toLowerCase());

</script>

</body>
</html>