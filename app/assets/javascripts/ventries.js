try {
  var SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
  var recognition = new SpeechRecognition();
}
catch(e) {
  console.error(e);
  $('.app').hide();
}

var noteContent = '';

/*-----------------------------
      Voice Recognition
------------------------------*/

// When false, the recording will stop after a few seconds of silence.
// When true, the silence period is longer (about 15 seconds)
recognition.continuous = true;

// This block is called every time the Speech APi captures a line.
recognition.onresult = function(event) {
  $('#recording-instructions').html("Shh... shut up. Some results are in.");
  // event is a SpeechRecognitionEvent object.
  // It holds all the lines we have captured so far.
  // We only need the current one.
  var current = event.resultIndex;

  // Get a transcript of what was said.
  var transcript = event.results[current][0].transcript;

  // Reset textarea to current transcript and run a text-to-data parsing function.
  // There is a weird bug on mobile, where everything is repeated twice. There is no official solution so far so we have to handle an edge case.
  var mobileRepeatBug = (current == 1 && transcript == event.results[0][0].transcript);

  if(!mobileRepeatBug) {
    noteContent = transcript;
    parseToForm(noteContent);
    $('#raw-textarea').val(noteContent);
  }
};

recognition.onstart = function() {
  $('#recording-instructions').html("Voice recognition is listening.");
}

recognition.onspeechend = function() {
  $('#recording-instructions').html('You were quiet for a while so voice recognition turned itself off.');
}

recognition.onerror = function(event) {
  if(event.error == 'no-speech') {
    $('#recording-instructions').html('I cannot hear you. No speech was detected.');
  };
}

/*-----------------------------
      App buttons and input
------------------------------*/

// Handled as inline button events because Bootstrap

// $('#start-record-btn').on('click', function(e) {
//   noteContent = '';
//   recognition.start();
// });

// $('#pause-record-btn').on('click', function(e) {
//   recognition.stop();
//   instructions.text('Voice recognition paused.');
// });

/*-----------------------------
     Translate to Data
------------------------------*/

var parseToForm = function (txt) {
  var days = {"monday":"Mon", "tuesday":"Tue", "wednesday":"Wed", "thursday":"Thu", "friday":"Fri", "saturday":"Sat", "sunday":"Sun"}
  var numbs = {"zero":"0", "one":1, "two":2, "to":2, "too":2, "three":3, "four":4, "for":4, "five":5, "six":6, "seven":7, "eight":8, "nine":9}
  var mystartoffset = {"Mon":0, "Tue":1, "Wed":2, "Thu":3, "Fri":4, "Sat":5, "Sun":6}
  var wordArr = txt.split(' ');
  var buildShows = [];
  var buildQty = [];
  var buildhtm = '';
  var eveningShift = true; //

  for (var i=0; i<wordArr.length; i++) {
    if (days[wordArr[i].toLowerCase()]){
      buildShows.push(days[wordArr[i].toLowerCase()]);
    }
    if (numbs[wordArr[i].toLowerCase()]){
      buildQty.push(numbs[wordArr[i].toLowerCase()]);
    }
    //Add numbers where string begins with 1-9
    if (wordArr[i].charCodeAt(0) > 47 && wordArr[i].charCodeAt(0) < 58){
      buildQty.push(wordArr[i]);
    }
  }

  //Build a preview...
  //Change this to add to form post or a Json API submision.
  // for (var i = 0; i<buildShows.length; i++){
  //   buildhtm += "<br>" + buildQty[i] + " : " + buildShows[i];
  //   if (buildShows[i+1] == buildShows[i]){
  //     buildhtm += " Mat";
  //   }else{
  //     if (buildShows[i] == "Sun"){
  //       if (buildShows[i-1] == "Sun"){
  //         buildhtm += " Eve";
  //       }else{
  //         buildhtm += " Mat";
  //       }
  //     }else{
  //       buildhtm += " Eve";
  //     }
  //   }
  // }

  //Product ID
  // buildhtm += "<input type=\"hidden\" value="10" name=\"ventry[product_id]\" id=\"ventry_product_id\">"
  // buildhtm += "<input type=\"hidden\" value="0" name=\"ventry[language]\" id=\"ventry_language\">"

  for (var i = 0; i<buildShows.length; i++){
    buildhtm += "<div class=\"row\">"

    if (buildShows[i+1] == buildShows[i]){
      eveningShift = false;
    }else{
      if (buildShows[i] == "Sun"){
        if (buildShows[i-1] == "Sun"){
          eveningShift = true;
        }else{
          eveningShift = false;
        }
      }else{
        eveningShift = true;
      }
    }
    buildhtm += "<input value=\"" + mystartoffset[buildShows[i]] + "\" type=\"hidden\" name=\"ventry" + i + "[weekday]\" id=\"ventry" + i + "_weekday\" >";
    buildhtm += "<input value=\"" + eveningShift + "\" type=\"hidden\" name=\"ventry" + i + "[eve]\" id=\"ventry" + i + "_eve\" >";
    buildhtm += "<input value=\"" + buildQty[i] + "\" type=\"hidden\" name=\"ventry" + i + "[qty]\" id=\"ventry" + i + "_qty\" >";

    buildhtm += "<div class=\"col-sm-6 editbold rt\">" + buildShows[i]
    if (eveningShift) { buildhtm += " Eve";
    }else{ buildhtm +=" Mat"; }
    buildhtm += "<\/div>";
    //<input value="0" tabIndex="2000" type="number" name="distributed5[quantity]" id="distributed5_quantity" />
    //<input value="7" type="hidden" name="distributed15[product_id]" id="distributed15_product_id" />
    buildhtm += "<div class=\"col-sm-4 editbold lt tight\"><input value=\"" + buildQty[i] + "\" type=\"number\"><\/div><\/div>";
  }

  buildhtm += "<input value=\"" + i + "\" type=\"hidden\" name=\"shiftcount\" id=\"shiftcount\" >";

  $('#myResults').html(buildhtm);
}
