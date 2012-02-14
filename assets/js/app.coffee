$ ->
  
  # Model
  Settings = Backbone.Model.extend
    # defaults:
    validation:
      username:
        required: true
      password:
        required: true
  
  # Collection
  SettingsCollection = Backbone.Collection.extend
    model: Settings
    
    localStorage: new Store 'settings'
    
    settingsId: 'settings'
    
    initialize: ->
      this.fetch()
      settings = this.get settingsId
      if !settings
        settings = new Settings
        this.add settings
        settings.save()
        
  # View
  SettingsView = Backbone.View.extend
    el: $('#dialog_settings')

    initialize: ->
      that = this
      Backbone.Validation.bind(this, {
        valid:
          (view, attr) ->
            that.$el.find("input[name='#{attr}']").parents('.control-group').removeClass 'error'
        invalid:
          (view, attr, error) ->
            that.$el.find("input[name='#{attr}']").parents('.control-group').addClass 'error'
      })
      Backbone.ModelBinding.bind this

    render: ->
      this.$el.modal()
      return this

  # Wires
  settingsView = new SettingsView
  $('#settings').bind 'click', ->
    settingsView.render()
    return false