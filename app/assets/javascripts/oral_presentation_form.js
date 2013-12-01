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
(function() {
    var DAYS = [
      {name: "Mon", dayId: 1},
      {name: "Tue", dayId: 2},
      {name: "Wed", dayId: 3},
      {name: "Thu", dayId: 4},
      {name: "Fri", dayId: 5}
    ];

    var renderForm = function($widget) {
        var $parent = $widget.find('.available-parent');
        var $field = $widget.find('.available-field');
        var disabled = $widget.hasClass('disabled');

        var available = new Available({
            days: DAYS,
            "$parent": $parent,
            disabled: disabled,
            onChanged: function (availableIntervals) {
                var asJson = JSON.stringify(availableIntervals);
                $field.val(asJson);
            }
        });
        var fromJson = JSON.parse($field.val());
        available.deserialize(fromJson);
    };

    $(document).ready(function () {
        $('.available-widget').each(function () {
            renderForm($(this));
        });
    });
})();
