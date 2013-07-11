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
    import org.dropframework.core.commons.DropFrameworkError;
    import org.dropframework.core.actors.ContextAwareActor;
    import org.dropframework.mvc.commons.IViewAdapter;


    /**
     * Simple extension of the ContextAwareController class which requires the view object to be supplied as a
     * constructor argument, thus providing view layer management capabilities.
     *
     * Referencing the view object is achievable through the protected 'adapter' field.
     *
     * Designed for extension by subclasses.
     *
     * @author jdanilov
     * */
    public class Mediator extends ContextAwareActor
    {
        private var _adapter : IViewAdapter;


        /** Mediator's view adapter. Non null. */
        protected function get adapter () : IViewAdapter
        {
            return _adapter;
        }



        /**
         * Creates new Mediator for a given display object. Automatically registers itself in the context.
         *
         * @param context - context to be used by the controller.
         * @param displayObject - displayObject to be used by the controller.
         * @throws org.dropframework.core.commons.DropFrameworkError if displayObject is null.
         * */
        public function Mediator
                (context : IContext, displayObject : DisplayObject)
        {
            super(context);

            if (displayObject == null)
                throw new DropFrameworkError("Supplied displayObject can not be null");

            this._adapter = new ViewAdapter(displayObject);
        }
    }
}