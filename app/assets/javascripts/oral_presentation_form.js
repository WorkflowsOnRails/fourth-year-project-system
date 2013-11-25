/**
 * Javascript module containing the rendering logic used for the
 * the oral presentation scheduling forms. The exported methods
 * are invoked in the appropriate oral presentation scheduling
 * action views.
 *
 * See the documentation for available.js for more information on how
 * this code functions.
 *
 * @author Brendan MacDonell
 */
var OralPresentationForm = (function() {
    var DAYS = [
      {name: "Mon", dayId: 1},
      {name: "Tue", dayId: 2},
      {name: "Wed", dayId: 3},
      {name: "Thu", dayId: 4},
      {name: "Fri", dayId: 5}
    ];

    var renderForm = function(options) {
        var $serialized = $(options.fieldSelector);
        var available = new Available({
            days: DAYS,
            "$parent": $(options.parentSelector),
            disabled: options.disabled,
            onChanged: function (availableIntervals) {
                var asJson = JSON.stringify(availableIntervals);
                $serialized.val(asJson);
            }
        });
        var fromJson = JSON.parse($serialized.val());
        available.deserialize(fromJson);
    };

    return {
        renderAcceptForm: function () {
            renderForm({
                parentSelector: '#accept-oral-form',
                fieldSelector: '#accept_available_times',
                disabled: true
            });
        },
        renderSubmitForm: function () {
            renderForm({
                parentSelector: '#submit-oral-form',
                fieldSelector: '#submit_available_times'
            });
        }
    };
})();
