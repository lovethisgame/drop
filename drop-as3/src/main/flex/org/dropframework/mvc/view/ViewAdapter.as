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

    import org.dropframework.mvc.commons.IViewAdapter;


    /**
     * Support class, represents a single ViewAdapter over the DisplayObject. User by Presenter to carry on view related
     * functionality. Default IViewAdapter implementation.
     *
     * ViewAdapter created by a single Presenter at construction time and used to access the controlled DisplayObjects.
     *
     * @author jdanilov
     * */
    public class ViewAdapter implements IViewAdapter
    {
        /** View instance wrapped by adapter */
        protected var _view : DisplayObject;

        /** View events listener that wraps view to provide delayed calls functionality. Instantiated on demand. */
        protected var eventsListener : ViewEventsListener;

        /** Creation guard that wraps view to provide delayed calls functionality. Instantiated on demand. */
        protected var creationGuard  : CreationGuard;



        /**
         * Creates new ViewAdapter for a given DisplayObject.
         *
         * @param view - view to wrap.
         * */
        public function ViewAdapter (view : DisplayObject)
        {
            this._view = view;
        }



        public function get view () : DisplayObject
        {
            return _view;
        }


        public function get isObjectCreated () : Boolean
        {
            if (creationGuard == null)
            {
                creationGuard = new CreationGuard(view);
                if (isDestroyed)
                {
                    creationGuard.destroy();
                }
            }

            return creationGuard.isObjectCreated;
        }


        public function callOnceCreated (f : Function, args : Array = null) : void
        {
            if (creationGuard == null)
            {
                creationGuard = new CreationGuard(view);
                if (isDestroyed)
                {
                    creationGuard.destroy();
                }
            }

            creationGuard.callOnceCreated(f, args);
        }


        public function cleanDelayedCalls (f : Function = null) : void
        {
            if (creationGuard == null)
            {
                creationGuard = new CreationGuard(view);
                if (isDestroyed)
                {
                    creationGuard.destroy();
                }
            }

            creationGuard.cleanDelayedCalls(f);
        }


        public function onActions
                (actionNames : Array /* <String> */, listener : Function /* (event : ViewEvent) */) : void
        {
            if (eventsListener == null)
            {
                eventsListener = new ViewEventsListener(view);
                if (isDestroyed)
                {
                    eventsListener.destroy();
                }
            }

            eventsListener.onActions(actionNames, listener);
        }


        public function onUnmappedActions (listener : Function  /* (event : ViewEvent) */) : void
        {
            if (eventsListener == null)
            {
                eventsListener = new ViewEventsListener(view);
                if (isDestroyed)
                {
                    eventsListener.destroy();
                }
            }

            eventsListener.onUnmappedActions(listener);
        }


        public function get isDestroyed () : Boolean
        {
            return (view == null);
        }


        public function destroy () : void
        {
            if (isDestroyed)
                return;

            if (creationGuard != null)
            {
                creationGuard.destroy();
            }

            _view = null;
        }
    }
}