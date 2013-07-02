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
package org.dropframework.core.contexts
{

    import org.dropframework.core.actors.IConcernedActor;


    /**
     * Central Context that keeps all actors in one place. Allows to register Actors in for later lookup.
     *
     * @author jdanilov
     * */
    public interface IContext
    {
        /**
         * Registers actor in the context. Actor will become available through the lookup.
         *
         * @param actor actor to register.
         * */
        function register (actor : IConcernedActor) : void;


        /**
         * Removes actor from a context. Actor will no longer be available through the lookup.
         *
         * @param actor actor to remove.
         * */
        function remove (actor : IConcernedActor) : void;


        /**
         * Returns an array of actors of a given Observer Interface / Class.
         *
         * @param type class/interface of the instances to lookup for.
         * @return non null array of actors of a given type.
         * */
        function arrayOf (type : Class) : Array /* <type> */;


        /**
         * Returns an actor referenced by a given type if exists.
         *
         * @param type - String/Class to lookup service instance by.
         * @return a service instance for a given locator.
         * @throws org.dropframework.core.commons.DropFrameworkError - if more than one controller found for the
         * specified locator.
         * */
        function instanceOf (type : Class) : IConcernedActor /* <type> */;


        /**
         * Iterates over an array of the actors of targetType calling supplied callback function for the every instance,
         * passing instances one by one into the callback function as an argument. If no instances found of a given type
         * then callback won't be called.
         *
         * @param targetType type to resolve actors by.
         * @param callback a <code>function (actor : targetType) : *</code> called for every actor of a given type found
         * in the context.
         */
        function invoke (targetType : Class, callback : Function /* (c : targetType) */) : void;
    }
}
