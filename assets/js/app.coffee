$ ->
  
  # Model
  Settings = Backbone.Model.extend
    defaults:
      id:       'settings'
      project:  ''
      username: ''
      password: ''

    validation:
      project:
        required: true
        minLength: 1
      username:
        required: true
        minLength: 1
      password:
        required: true
        minLength: 1
      # releases:
      #   required: true
    
    can_access_jira: ->
      return project != '' and username != '' and password != ''
  
  # Collection
  SettingsCollection = Backbone.Collection.extend
    model: Settings
    
    localStorage: new Store 'settings'
    
    settingsId: 'settings'
    
    initialize: ->
      this.fetch()
      settings = this.get this.settingsId
      if !settings
        settings = new Settings
        this.add settings
        settings.save()
        
  # View
  SettingsView = Backbone.View.extend
    el: $('#dialog_settings')
    
    events:
      'click :button[type="submit"]': 'update'
      'click :button[type="cancel"]': 'toggle'
      'keypress :input': 'submit'

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
      Backbone.ModelBinding.bind(this, {
        text: 'name'
        password: 'name'
      })

    render: ->
      this.$el.modal()
      return this
      
    update: ->
      this.model.save(
        project:  this.$el.find('input[name="project"]').val()
        username: this.$el.find('input[name="username"]').val()
        password: this.$el.find('input[name="password"]').val()
      )
      if this.model.isValid()
        this.model.save()
        this.toggle()
      
    submit: (e) ->
      if e.keyCode == 13
        this.update()
      
    toggle: ->
      this.$el.modal 'toggle'

  # Wires
  settingsCollection = new SettingsCollection
  model = settingsCollection.get settingsCollection.settingsId
  
  # Poll jira for releases
  if model.can_access_jira
    console.log 'hi'

  settingsView = new SettingsView model: model
  $('#settings').bind 'click', ->
    settingsView.render()
    return false

