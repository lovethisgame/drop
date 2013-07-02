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

    import mx.core.UIComponent;
    import mx.events.FlexEvent;

    import org.dropframework.mvc.commons.ICreationGuard;

    import org.dropframework.mvc.commons.IDestroyable;


    /**
     * Default ICreationGuard interface implementation.
     *
     * Delays all calls till the wrapped object is created (for UIComponent a CREATION_COMPLETE event is thrown).
     *
     * @author jdanilov
     */
    public class CreationGuard implements ICreationGuard, IDestroyable
    {
        /** Object wrapped. */
        protected var object : Object;

        /** True if the object has been created so far. */
        protected var _objectCreated : Boolean = false;

        /** Array of delayed calls. */
        protected var delayedCalls : Vector.<Object> = new Vector.<Object>();



        /**
         * Creates guard for the object supplied.
         *
         * @param object UIComponent or Object to guard. If UIComponent is supplied, it supposed to be created when the
         * CREATION_COMPLETE event is thrown on it. If any other type is supplied, the object is supposed to be already
         * created. If null supplied the object is considered to be never created.
         */
        public function CreationGuard (object : Object)
        {
            this.object = object;

            if (object == null)
            {
                _objectCreated = false;
            }
            else if (object is UIComponent && !(object as UIComponent).initialized)
            {
                (object as UIComponent).addEventListener
                        (FlexEvent.CREATION_COMPLETE, ccHandler, false, -1);
            }
            else
            {
                _objectCreated = true;
            }
        }



        public function get isObjectCreated () : Boolean
        {
            return _objectCreated;
        }


        public function callOnceCreated (f : Function, args : Array = null) : void
        {
            if (_objectCreated)
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


        public function get isDestroyed () : Boolean
        {
            return object == null;
        }


        public function destroy () : void
        {
            if (isDestroyed)
                return;

            cleanDelayedCalls();
            object = null;
        }



        /**
         * Default function invoked on creation complete event of the UIComponent. Marks component as created and
         * processes all delayed calls.
         *
         * @param event dispatched creation complete event.
         */
        protected function ccHandler (event : FlexEvent) : void
        {
            _objectCreated = true;
            if (isDestroyed)
            {
                delayedCalls = null;
                return;
            }

            (object as UIComponent).removeEventListener
                    (FlexEvent.CREATION_COMPLETE, ccHandler);

            for each (var call : Object in delayedCalls)
            {
                call.f.apply(call.args);
            }
        }
    }
}