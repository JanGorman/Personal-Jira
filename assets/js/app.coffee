$ ->
  
  Settings = Backbone.Model.extend
  
  
  SettingsView = Backbone.View.extend
    el: $('#dialog_settings')

    render: ->
      this.$el.modal()
    
  settingsView = new SettingsView;
  $('.container').append(settingsView.el);
  
  $('#settings').bind 'click', ->
    settingsView.render()
    return false