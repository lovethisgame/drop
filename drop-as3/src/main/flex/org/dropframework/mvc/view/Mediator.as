/*
 * Copyright 2013 Drop Framework Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package org.dropframework.mvc.view
{

    import flash.display.DisplayObject;

    import org.dropframework.core.contexts.IContext;
    import org.dropframework.core.actors.ContextAwareActor;
    import org.dropframework.mvc.commons.guards.CreationGuard;
    import org.dropframework.mvc.commons.guards.ICreationGuard;


    /**
     * Simple extension of the ContextAwareController class which requires the view object to be supplied as a
     * constructor argument, thus providing view layer management capabilities.
     *
     * Referencing the view object is achievable through the protected 'view' field.
     *
     * Designed for extension by subclasses.
     *
     * @author jdanilov
     * */
    public class Mediator
            extends ContextAwareActor
    {
        private var _view  : DisplayObject;
        private var _guard : ICreationGuard;


        /** Mediator's view adapter. Non null. */
        protected function get view () : DisplayObject
        {
            return _view;
        }


        /** Mediator's view creation guard. Non null. */
        protected function get guard () : ICreationGuard
        {
            return _guard;
        }



        /**
         * Creates new Mediator for a given display object. Automatically registers itself in the context.
         *
         * @param context - context to be used by the controller.
         * @param view - displayObject to be used by the controller.
         * */
        public function Mediator
                (context : IContext, view : DisplayObject)
        {
            super(context);
            mediate(view);
        }


        /**
         * Switches Mediator to mediate over a new View.
         *
         * If new View is the same as current one, nothing happens.
         *
         * ViewAdapter will be updated automatically meaning all view listeners preserved but re-directed to a new View
         * instance. CreationGuard however will be cleaned off and re-initialized so the queue of delayed calls (if any)
         * for the previous View will never be executed.
         *
         * If supplied object is null, Mediator stops mediating any View.
         *
         * @param view - a View to mediate over.
         */
        protected function mediate (view : DisplayObject) : void
        {
            _view = view;

            if (_guard)
            {
                if (_guard.view == view)
                    return;
                _guard.view = view;
            }
            else
            {
                if (view)
                {
                    _guard = new CreationGuard(view);
                }
            }
        }
    }
}