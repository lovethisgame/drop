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


    /**
     * Guard proxy which delays all requests to the wrapped view until it's fully created to process the calls.
     *
     * @author jdanilov
     */
    public interface ICreationGuard
    {

        /**
         * Applies the given DisplayObject as a view to wrap.
         */
        function set view (value : DisplayObject) : void;


        /**
         * Returns the DisplayObject wrapped by the CreationGuard.
         * */
        function get view () : DisplayObject;


        /**
         * Returns true if the guarded view has been created.
         *
         * @result true if the object has been created.
         * */
        function get isViewCreated () : Boolean;


        /**
         * Calls function f with specified list of arguments once the guarded object is created. Call processed
         * immediately if the guarded view already created.
         *
         * @param f function to be invoked once the guarded view created.
         * @param args array of arguments to be passed to the function. If null, function will be called with no
         * arguments.
         */
        function callOnceCreated (f : Function, args : Array = null) : void;


        /**
         * Cleans delayed calls for the specified function f.
         *
         * @param f function, calls to which to be removed from the delayed calls queue. If null passed all calls will
         * be removed.
         * */
        function cleanDelayedCalls (f : Function = null) : void;
    }
}