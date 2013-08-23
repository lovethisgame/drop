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
package org.dropframework.mvc.commons.adapter
{
    import org.dropframework.core.commons.DropFrameworkError;
    import org.dropframework.mvc.commons.events.ViewEvent;
    import flash.display.DisplayObject;


    /**
     * Support class, represents a single ViewAdapter over the DisplayObject. User by Mediator to carry on view related
     * functionality. Default IViewAdapter implementation.
     *
     * ViewAdapter created by a single Mediator at construction time and used to access the controlled DisplayObjects.
     *
     * @author jdanilov
     * */
    public class ViewAdapter implements IViewAdapter
    {
        /** DisplayObject representing the view being observed. */
        private var _view : DisplayObject;

        /** List of monitored action names. */
        private var actionsNames : Vector.<String> = new Vector.<String>();

        /** List of registered action listeners. */
        private var actionsListeners : Vector.<Function> = new Vector.<Function>();

        /** Listener function to be called if unregistered action occurs. */
        private var unmappedActionListener : Function = null;


        /**
         * Creates new instance of the ViewAdapter listening over supplied displayObject.
         *
         * @param view view to register listener on.
         */
        public function ViewAdapter (view : DisplayObject)
        {
            this.view = view;
        }


        public function set view (value : DisplayObject) : void
        {
            if (this._view)
            {
                _view.removeEventListener(ViewEvent.ACTION, handleActionEvent);
            }

            this._view = value;
            value.addEventListener(ViewEvent.ACTION, handleActionEvent);
        }


        public function get view ():DisplayObject
        {
            return _view;
        }


        public function on
                (actionNames : Object /* Array<String> or String */,
                 listener : Function /* (event : ViewEvent) */) : void
        {
            if (actionNames == null)
                throw new DropFrameworkError("Supplied actionNames can not be null. Array or String expected.");

            if (actionNames is Array)
            {
                for (var i : int = 0; i < (actionNames as Array).length; i++)
                {
                    actionsNames.push(actionNames[i]);
                    actionsListeners.push(listener);
                }
            }
            else if (actionNames is String)
            {
                actionsNames.push(actionNames);
                actionsListeners.push(listener);
            }
            else
            {
                throw new DropFrameworkError("Supplied actionNames should either be Array<String> or String.");
            }
        }


        public function onUnmappedAction (listener : Function /* (event : ViewEvent) */) : void
        {
            this.unmappedActionListener = listener;
        }


        /**
         * General listener function for events of type ViewEvent.ACTION dispatched on a view.
         *
         * @param event dispatched event.
         */
        private function handleActionEvent (event : Object) : void
        {
            if (!(event is ViewEvent) || !this._view)
                return;

            // first attempting to resolve a registered listener
            var found : Boolean = false;
            for (var i : int = 0; i < actionsNames.length; i++)
            {
                if (actionsNames[i] == event.actionName)
                {
                    found = true;
                    actionsListeners[i](event);
                }
            }

            // if nothing registered for the action name an unmapped listener will be called
            if (!found && unmappedActionListener != null)
            {
                unmappedActionListener(event);
            }
        }
    }
}