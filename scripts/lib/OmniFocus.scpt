FasdUAS 1.101.10  scptJsOsaDAS1.001.00bplist00�Vscript_�
/**
*
* @method getFolder
* @param {string} folderName - Name of folder to get
* @return {function} First folder whose name matches `folderName`
*
*/
function getFolder(folderName) {
	return doc.flattenedFolders.whose({name: folderName})[0];
}

/**
*
* @method listTitles
* @param {array} list - List of tasks to pull titles from
* @return {string} Concatenated list of titles
*
*/
function listTitles(list) {
  var text = '';
  list.forEach(function(task) {
    text += task.name() + '\n';
  });
  return text;
}

/**
*
* @method copy
* @param {string} text - Text to copy to clipboard
* @return {null}
*
*/
function copy(text) {
  app.setTheClipboardTo(text);
}

/**
*
* @method complete
* @param {array} list - List of tasks to complete
* @return {null}
*
*/
function complete(list) {
  list.forEach(function(task) {
    task.completed = true;
  });
}

/**
*
* @method toggleSequential
* @param {array} list - List of projects and actions to toggle
* @return {null}
*
*/
function toggleSequential(list) {
  list.forEach(function(task) {
    try {
      if (task.sequential() === true) {
        task.sequential = false;
      } else {
        task.sequential = true;
      }
    }
    catch (e) {
      console.log(e);
    }
  });
}

/**
*
* @method alert
* @param {string} text - Text to display as alert dialog
* @return {null}
*
*/
function alert(text) {
  app.displayAlert(text);
}

/**
*
* @method openPerspective
* @param {string} perName - Name of perspective to open
*
*/
function openPerspective(perName) {
	app.launch();
	var window = app.windows[0];
	if (window.visible()) {
		window.perspectiveName = perName;
	}
}

/**
*
* @method inboxCount
* @return {number} Number of inbox tasks
*
*/
function inboxCount() {
 return doc.inboxTasks.length;
}

/**
*
* @method errandCount
* @return {number} Number of errands
*
*/
function errandCount() {
 return getContext("Errands").availableTaskCount();
}
/**
*
* @method firstCount
* @return {number} Number of "@First Thing" tasks
*
*/
function firstCount() {
  return getContext('First Thing').availableTaskCount();
}

/**
*
* @method flaggedCount
* @return {number} Number of flagged tasks
*
*/
function flaggedCount() {
  return doc.flattenedTasks.whose({completed: false, flagged: true, blocked: false}).length;
}

/**
*
* @method routineCount
* @return {number} Number of tasks in a folder titled "Routine"
*
*/
function routineCount() {
  var folder = getFolder('Routine');
  var tasks = 0;
  folder.projects().forEach(function(project) {
    tasks += project.numberOfAvailableTasks();
  });
  return tasks;
}

/**
*
* @method landAndSeaCount
* @return {number} Number of tasks in a project titled "Land & Sea"
*
*/
function landAndSeaCount() {
  var project = getProject('Land & Sea');
  return project.numberOfAvailableTasks();
}

/**
*
* @method prependText
* @param {array} list - The tasks to be acted on
* @param {string} text - The text to be prepended
*
*/
function prependText(list, text) {
  list.forEach(function(task) {
    var oldTitle = task.name();
    task.name = text + ' ' + oldTitle;
  });
}

/**
*
* @method appendText
* @param {array} list - The tasks to be acted on
* @param {string} text - The text to be appended
*
*/
function appendText(list, text) {
  list.forEach(function(task) {
    var oldTitle = task.name();
    task.name = oldTitle + ' ' + text;
  });
}

/**
*
* @method computerName
* @return {string} Name of local computer
*
*/
function computerName() {
  return current.doShellScript("scutil --get ComputerName");
}
                              � ascr  ��ޭ