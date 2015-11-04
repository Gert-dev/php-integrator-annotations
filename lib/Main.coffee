{Disposable} = require 'atom'

MethodProvider = require './MethodProvider'
PropertyProvider = require './PropertyProvider'

module.exports =
    ###*
     * List of annotation providers.
    ###
    providers: []

    ###*
     * Activates the package.
    ###
    activate: ->

    ###*
     * Deactivates the package.
    ###
    deactivate: ->
        @deactivateProviders()

    ###*
     * Activates the providers using the specified service.
    ###
    activateProviders: (service) ->
        @providers = []

        @providers.push new MethodProvider()
        @providers.push new PropertyProvider()

        for provider in @providers
            provider.activate(service)

    ###*
     * Deactivates any active providers.
    ###
    deactivateProviders: () ->
        for provider in @providers
            provider.deactivate()

        @providers = []

    ###*
     * Sets the php-integrator service.
     *
     * @param {mixed} service
    ###
    setService: (service) ->
        @activateProviders(service)

        return new Disposable => @deactivateProviders()
