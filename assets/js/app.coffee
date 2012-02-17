$ ->
  
  # Model
  Settings = Backbone.Model.extend
    defaults:
      id:       'settings'
      url:      ''
      wsdl:     ''
      project:  ''
      username: ''
      password: ''

    validation:
      wsdl:
        required: true
        minLength: 1
      project:
        required: true
        minLength: 1
      username:
        required: true
        minLength: 1
      password:
        required: true
        minLength: 1
    
    can_access_jira: ->
      return this.get('wsdl') and this.get('project') and this.get('username') and this.get('password')
      
  Issue = Backbone.Model.extend
    
    idAttribute: 'key'
  
    defaults:
      key:      ''
      summary:  ''
  
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

  IssueCollection = Backbone.Collection.extend
    model: Issue

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

  IssueView = Backbone.View.extend
    template: _.template($('#issue-template').html())
  
    initialize: ->
      _.bindAll this
      this.model.bind 'change', this.render, this
      this.model.bind 'destroy', this.remove, this
  
    render: ->
      this.$el.html this.template this.model.toJSON()
      return this
      
    remove: ->
      this.$el.remove();
  
  IssuesView = Backbone.View.extend
  
    el: $('#issues')
    
    initialize: ->
      issues.bind 'add', this.addOne, this
      
    clear: ->
      this.$el.empty();
      
    addOne: (issue)->
      issue = new IssueView(model: issue)
      $('#issues').append issue.render().el
      
    addAll: ->
      issues.each this.addOne
  
  issues = new IssueCollection
  issuesView = new IssuesView

  # Wires
  settingsCollection = new SettingsCollection
  model = settingsCollection.get settingsCollection.settingsId

  $('#release').bind 'keypress', (e) ->
    if e.keyCode == 13 and model.can_access_jira
      $('#progress').modal 'show'

      access = (
        wsdl:     model.get 'wsdl'
        project:  model.get 'project'
        username: model.get 'username'
        password: model.get 'password'
        release:  $('#release').val()
      )
      $.getJSON '/issues', access, (data) ->
        $('#progress').modal 'hide'
        if data.length == 0
          $('.container h1').text 'Time for a beer, you\'re all done!'
        else
          $('.container h1').text 'Still something left to do:'

        issuesView.clear()
        _.each data, (item) ->
          issue = new Issue(
            url: "#{model.get 'url'}/browse/#{item.key}"
            key: item.key
            summary: item.summary
          )
          issues.remove issue
          issues.add issue

      return false
  
  # Poll jira for releases
  if model.can_access_jira()
    access = (
      wsdl:     model.get 'wsdl'
      project:  model.get 'project'
      username: model.get 'username'
      password: model.get 'password'
    )
    
    $('#progress').modal(
      keyboard: false
    )
    
    $.getJSON '/releases', access, (data) ->
      $('#progress').modal 'hide'
      $('#release').typeahead(
        source: data
        items: 10
      )

  settingsView = new SettingsView model: model
  $('#settings').bind 'click', ->
    settingsView.render()
    return false

