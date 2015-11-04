AbstractProvider = require './AbstractProvider'

module.exports =

##*
# Provides annotations for member methods that are overrides or interface implementations.
##
class MethodProvider extends AbstractProvider
    ###*
     * @inheritdoc
    ###
    registerAnnotations: (editor) ->
        currentClass = @service.determineFullClassName(editor)

        return if not currentClass

        @service.getClassInfo(currentClass, true).then (currentClassInfo) =>
            return if not currentClassInfo

            for name, property of currentClassInfo.properties
                continue if not property.override

                regex = new RegExp("^([\\t\\ ]*)(?:public|protected|private)\\s+\\$" + name + "\\s+")

                editor.getBuffer().scan(regex, (matchInfo) =>
                    # Remove the spacing from the range.
                    matchInfo.range.start.column += matchInfo.match[1].length

                    @placeAnnotation(editor, matchInfo.range, @extractAnnotationInfo(property))

                    matchInfo.stop()
                )

    ###*
     * Fetches annotation info for the specified context.
     *
     * @param {Object} context
     *
     * @return {Object}
    ###
    extractAnnotationInfo: (context) ->
        # NOTE: We deliberately show the declaring class here, not the structure (which could be a trait).
        return {
            lineNumberClass : 'override'
            tooltipText     : 'Overrides property from ' + context.override.declaringClass.name
            extraData       : context.override
        }

    ###*
     * @inheritdoc
    ###
    handleMouseClick: (event, editor, annotationInfo) ->
        atom.workspace.open(annotationInfo.extraData.declaringStructure.filename, {
            initialLine    : annotationInfo.extraData.startLine - 1,
            searchAllPanes : true
        })

    ###*
     * @inheritdoc
    ###
    removePopover: () ->
        if @attachedPopover
            @attachedPopover.dispose()
            @attachedPopover = null
