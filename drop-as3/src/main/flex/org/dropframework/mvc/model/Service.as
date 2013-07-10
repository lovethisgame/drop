package org.dropframework.mvc.model
{
    import org.dropframework.core.actors.ContextAwareActor;
    import org.dropframework.core.contexts.IContext;


    /**
     * Simple extension of the ContextAwareActor class which encapsulates the specific model layer logic of the
     * application.
     *
     * Designed for extension by subclasses.
     *
     * @author jdanilov
     * */
    public class Service extends ContextAwareActor
    {
        /**
         * Creates new Service. Automatically registers itself in the context.
         *
         * @param context - context to be used by the controller.
         * */
        public function Service
                (context : IContext)
        {
            super(context);
        }
    }
}
