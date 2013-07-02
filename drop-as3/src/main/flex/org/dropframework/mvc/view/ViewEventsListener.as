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

    import org.dropframework.mvc.commons.IDestroyable;
    import org.dropframework.mvc.commons.IViewEventsListener;


    /**
     * Used to listen for view events using the mix of strategy and observer patterns where each strategy is a listener
     * function invoked for every ViewEvent instance of a specific action name.
     *
     * @author jdanilov
     * */
    public class ViewEventsListener implements IViewEventsListener, IDestroyable
    {
        /** DisplayObject representing the view being observed. */
        private var displayObject          : DisplayObject;

        /** List of monitored action names. */
        private var actionsNames           : Vector.<String> = new Vector.<String>();

        /** List of registered action listeners. */
        private var actionsListeners       : Vector.<Function> = new Vector.<Function>();

        /** Listener function to be called if unregistered action occurs. */
        private var unmappedActionListener : Function = null;


        /**
         * Creates new instance of the ViewEventsListener listening over supplied displayObject.
         *
         * @param displayObject view to register listener on.
         */
        public function ViewEventsListener (displayObject : DisplayObject)
        {
            this.displayObject = displayObject;
            displayObject.addEventListener(ViewEvent.ACTION, handleActionEvent);
        }



        public function onActions
                (actionNames : Array /* <String> */, listener : Function /* (event : ViewEvent) */) : void
        {
            if (isDestroyed)
                return;

            for (var i : int = 0; i < actionNames.length; i++)
            {
                actionsNames.push(actionNames[i]);
                actionsListeners.push(listener);
            }
        }


        public function onUnmappedActions (listener : Function /* (event : ViewEvent) */) : void
        {
            if (isDestroyed)
                return;

            this.unmappedActionListener = listener;
        }


        public function get isDestroyed () : Boolean
        {
            return (displayObject == null);
        }


        public function destroy () : void
        {
            if (isDestroyed)
                return;

            displayObject.removeEventListener(ViewEvent.ACTION, handleActionEvent);

            displayObject          = null;
            actionsNames           = null;
            actionsListeners       = null;
            unmappedActionListener = null;
        }



        /**
         * General listener function for events of type ViewEvent.ACTION dispatched on a view.
         *
         * @param event dispatched event.
         */
        private function handleActionEvent (event : Object) : void
        {
            if (!(event is ViewEvent) || isDestroyed)
                return;

            // first trying to resolve a registered listener
            var found : Boolean = false;
            for (var i : int = 0; i < actionsNames.length; i++)
            {
                if (actionsNames[i] == event.actionName)
                {
                    found = true;
                    actionsListeners[i](event);
                    if (isDestroyed)
                        return;
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