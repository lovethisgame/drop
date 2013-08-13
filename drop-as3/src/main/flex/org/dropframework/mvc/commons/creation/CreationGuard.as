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
package org.dropframework.mvc.commons.creation
{

    import flash.display.DisplayObject;

    import mx.core.UIComponent;
    import mx.events.FlexEvent;


    /**
     * Default ICreationGuard interface implementation.
     *
     * Delays all calls till the wrapped object is created (for UIComponent a CREATION_COMPLETE event is thrown).
     *
     * @author jdanilov
     */
    public class CreationGuard
            implements ICreationGuard
    {
        /** Wrapped view */
        protected var _view : DisplayObject;

        /** True if the object has been created */
        protected var _viewCreated : Boolean = false;

        /** Array of delayed calls */
        protected var delayedCalls : Vector.<Object> = new Vector.<Object>();



        /**
         * Creates guard for the object supplied.
         *
         * @param view UIComponent to guard. View is supposed to be created once it dispatches CREATION_COMPLETE event.
         */
        public function CreationGuard (view : DisplayObject)
        {
            this.view = view;
        }



        public function set view (value : DisplayObject) : void
        {
            if (this._view)
            {
                // first, clean off all delayed calls for the current object
                cleanDelayedCalls();
                if (this._view is UIComponent && !(this._view as UIComponent).initialized)
                {
                    // drop the creation complete listener
                    (this._view as DisplayObject).removeEventListener
                            (FlexEvent.CREATION_COMPLETE, ccHandler);
                }
            }

            this._view = value;
            if (value == null)
            {
                // consider the object not created if it's null
                _viewCreated = false;
            }
            else
            {
                if (value is UIComponent && !(value as UIComponent).initialized)
                {
                    // listener for creation complete on UIComponent
                    (value as UIComponent).addEventListener
                            (FlexEvent.CREATION_COMPLETE, ccHandler, false, -1);
                }
                else
                {
                    // consider object created already
                    _viewCreated = true;
                }
            }
        }


        public function get view () : DisplayObject
        {
            return _view;
        }


        public function get isViewCreated () : Boolean
        {
            return _viewCreated;
        }


        public function callOnceCreated (f : Function, args : Array = null) : void
        {
            if (_viewCreated)
            {
                f.apply(args);
            }
            else
            {
                delayedCalls.push({f : f, args : args});
            }
        }


        public function cleanDelayedCalls (f : Function = null) : void
        {
            if (f == null)
            {
                if (delayedCalls != null)
                {
                    delayedCalls = new Vector.<Object>();
                }
            }
            else
            {
                for (var i : int = 0; i < delayedCalls.length; i++)
                {
                    if (delayedCalls[i].call == f)
                    {
                        delayedCalls.splice(i--, 1);
                    }
                }
            }
        }



        /**
         * Default function invoked on creation complete event of the UIComponent. Marks component as created and
         * processes all delayed calls.
         *
         * @param event dispatched creation complete event.
         */
        protected function ccHandler (event : FlexEvent) : void
        {
            _viewCreated = true;
            if (_view == null)
            {
                delayedCalls = null;
                return;
            }

            // drop the creation complete listener
            (_view as UIComponent).removeEventListener
                    (FlexEvent.CREATION_COMPLETE, ccHandler);

            // call every delayed function in order
            for each (var call : Object in delayedCalls)
            {
                call.f.apply(call.args);
            }
        }
    }
}